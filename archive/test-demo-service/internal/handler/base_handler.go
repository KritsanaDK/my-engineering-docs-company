package handler

import (
	"context"
	"fmt"
	"net/http"
	"time"

	"test-demo-service/internal/config"
	"test-demo-service/internal/constant"
	"test-demo-service/internal/logger"
	"test-demo-service/internal/model"

	"github.com/go-playground/validator/v10"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/labstack/echo/v4"
)

type BaseHandler struct {
	cfg       *config.Config
	pool      *pgxpool.Pool
	validator *validator.Validate
	startTime time.Time
}

func NewBaseHandler(cfg *config.Config, pool *pgxpool.Pool) *BaseHandler {
	return &BaseHandler{
		cfg:       cfg,
		pool:      pool,
		validator: validator.New(),
		startTime: time.Now(),
	}
}

func (h *BaseHandler) ValidatorParam(req interface{}) error {
	if h.validator == nil {
		h.validator = validator.New()
	}
	err := h.validator.Struct(req)
	if err != nil {
		var errMsg string
		if validationErrors, ok := err.(validator.ValidationErrors); ok {
			for _, e := range validationErrors {
				errMsg += fmt.Sprintf("field '%s' failed on '%s' rule; ", e.Field(), e.Tag())
			}
		} else {
			errMsg = err.Error()
		}
		return fmt.Errorf("%s", errMsg)
	}
	return nil
}

func (h *BaseHandler) GenSuccessResponse(c echo.Context, response interface{}, tracking ...*model.Tracking) error {
	templateResponse := model.TemplateResponse{
		Code:    constant.CodeSuccess,
		Message: constant.MessageSuccess,
		Data:    response,
	}

	if len(tracking) > 0 && tracking[0] != nil {
		tracking[0].Response = templateResponse
		logger.InfoWithTracking(constant.Handler, tracking[0])
	}

	return c.JSON(http.StatusOK, templateResponse)
}

func (h *BaseHandler) GenCustomResponse(c echo.Context, response interface{}, code, message string, httpStatus int, tracking ...*model.Tracking) error {
	templateResponse := model.TemplateResponse{
		Code:    code,
		Message: message,
		Data:    response,
	}

	if len(tracking) > 0 && tracking[0] != nil {
		tracking[0].Response = templateResponse
		logger.InfoWithTracking(constant.Handler, tracking[0])
	}

	return c.JSON(httpStatus, templateResponse)
}

func (h *BaseHandler) GenErrorResponse(c echo.Context, code, message string, httpStatus int, tracking ...*model.Tracking) error {
	templateResponse := model.TemplateResponse{
		Code:    code,
		Message: message,
	}

	if len(tracking) > 0 && tracking[0] != nil {
		tracking[0].Response = templateResponse
		logger.ErrorWithTracking(constant.Handler, message, tracking[0])
	}

	return c.JSON(httpStatus, templateResponse)
}

func (h *BaseHandler) PreProcess(request interface{}, tracking *model.Tracking) {
	if tracking != nil {
		tracking.Request = request
		logger.Info("PreProcess|Request=%+v", request)
	}
}

func (h *BaseHandler) PostProcess(response interface{}, tracking *model.Tracking) {
	if tracking != nil {
		tracking.Response = response
		logger.Info("PostProcess|Response=%+v", response)
	}
}

func (h *BaseHandler) HealthCheck(c echo.Context) error {
	ctx, cancel := context.WithTimeout(c.Request().Context(), 2*time.Second)
	defer cancel()

	dbStatus := "healthy"
	isHealthy := true

	if h.pool != nil {
		if err := h.pool.Ping(ctx); err != nil {
			dbStatus = "unreachable"
			isHealthy = false
		}
	} else {
		dbStatus = "not configured"
	}

	statusCode := http.StatusOK
	statusText := "ok"
	if !isHealthy {
		statusCode = http.StatusServiceUnavailable
		statusText = "degraded"
	}

	return c.JSON(statusCode, echo.Map{
		"status":    statusText,
		"service":   h.cfg.App.Name,
		"env":       h.cfg.App.Env,
		"uptime":    time.Since(h.startTime).Truncate(time.Second).String(),
		"database":  dbStatus,
		"timestamp": time.Now().UTC().Format(time.RFC3339),
	})
}
