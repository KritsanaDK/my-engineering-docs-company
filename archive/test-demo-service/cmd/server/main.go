package main

import (
	"context"
	"errors"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"test-demo-service/internal/config"
	"test-demo-service/internal/handler"
	"test-demo-service/internal/logger"
	appMiddleware "test-demo-service/internal/middleware"
	"test-demo-service/internal/model"
	"test-demo-service/internal/repository"
	"test-demo-service/internal/service"

	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
	"go.uber.org/zap"
)

func initPGXPool(ctx context.Context, dbCfg config.DBConfig) (*pgxpool.Pool, error) {
	poolCfg, err := pgxpool.ParseConfig(dbCfg.DSN())
	if err != nil {
		return nil, err
	}
	poolCfg.MaxConns = dbCfg.MaxConns
	poolCfg.MinConns = dbCfg.MinConns
	poolCfg.MaxConnLifetime = dbCfg.MaxConnLifetime
	poolCfg.MaxConnIdleTime = dbCfg.MaxConnIdleTime

	return pgxpool.NewWithConfig(ctx, poolCfg)
}

func main() {
	if err := logger.InitializeLoggerSystem(); err != nil {
		panic(err)
	}
	defer logger.Sync()

	ctx := context.Background()
	cfg := config.LoadConfig()

	primaryPool, err := initPGXPool(ctx, cfg.DBPrimary)
	if err != nil {
		logger.Error("unable to connect to primary database: %v", err)
		os.Exit(1)
	}
	defer primaryPool.Close()

	if err := primaryPool.Ping(ctx); err != nil {
		logger.Warn("primary database ping warning: %v", err)
	} else {
		logger.Info("connected to primary database successfully")
	}

	userRepo := repository.NewUserRepo(primaryPool)
	userService := service.NewUserService(userRepo, cfg.JWT)

	baseHandler := handler.NewBaseHandler(cfg, primaryPool)
	authHandler := handler.NewAuthHandler(baseHandler, userService)
	userHandler := handler.NewUserHandler(baseHandler, userService)

	e := echo.New()
	e.HideBanner = true
	e.Server.ReadTimeout = cfg.App.ReadTimeout
	e.Server.WriteTimeout = cfg.App.WriteTimeout

	e.Use(middleware.RequestLoggerWithConfig(middleware.RequestLoggerConfig{
		LogStatus:   true,
		LogURI:      true,
		LogMethod:   true,
		LogLatency:  true,
		LogError:    true,
		HandleError: true,
		LogValuesFunc: func(c echo.Context, v middleware.RequestLoggerValues) error {
			if v.Error == nil {
				logger.InfoWithFields("HTTP Request",
					zap.String("method", v.Method),
					zap.String("uri", v.URI),
					zap.Int("status", v.Status),
					zap.Duration("latency", v.Latency),
				)
			} else {
				logger.ErrorWithFields("HTTP Error",
					zap.String("method", v.Method),
					zap.String("uri", v.URI),
					zap.Int("status", v.Status),
					zap.Duration("latency", v.Latency),
					zap.Error(v.Error),
				)
			}
			return nil
		},
	}))
	e.Use(middleware.Recover())
	e.Use(middleware.CORS())

	e.GET("/health", baseHandler.HealthCheck)

	api := e.Group("/api/v1")

	auth := api.Group("/auth")
	auth.POST("/register", authHandler.Register)
	auth.POST("/login", authHandler.Login)
	auth.GET("/me", authHandler.GetMe, appMiddleware.JWTAuthMiddleware(cfg.JWT.Secret))

	users := api.Group("/users", appMiddleware.JWTAuthMiddleware(cfg.JWT.Secret))
	users.GET("/:id", userHandler.GetByID)
	users.GET("", userHandler.List, appMiddleware.RequireMinRole(model.RoleManager))
	users.POST("", userHandler.Create, appMiddleware.RequireRole(model.RoleAdmin, model.RoleSuperAdmin))
	users.PUT("/:id", userHandler.Update, appMiddleware.RequireRole(model.RoleAdmin, model.RoleSuperAdmin))
	users.DELETE("/:id", userHandler.Delete, appMiddleware.RequireRole(model.RoleSuperAdmin))

	go func() {
		addr := ":" + cfg.App.Port
		logger.Info("🚀 %s server [%s] starting on port %s", cfg.App.Name, cfg.App.Env, addr)
		if err := e.Start(addr); err != nil && !errors.Is(err, http.ErrServerClosed) {
			logger.Error("shutting down the server due to error: %v", err)
			os.Exit(1)
		}
	}()

	quit := make(chan os.Signal, 1)
	signal.Notify(quit, os.Interrupt, syscall.SIGTERM)
	<-quit

	logger.Info("shutdown signal received, gracefully draining connections...")

	shutdownCtx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	if err := e.Shutdown(shutdownCtx); err != nil {
		logger.Error("server forced to shutdown: %v", err)
	}

	logger.Info("server gracefully stopped")
}
