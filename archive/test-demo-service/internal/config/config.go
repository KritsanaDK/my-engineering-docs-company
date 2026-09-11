package config

import (
	"fmt"
	"os"
	"strconv"
	"time"

	"github.com/joho/godotenv"
)

type AppConfig struct {
	Name         string        `json:"name"`
	Port         string        `json:"port"`
	Env          string        `json:"env"`
	ReadTimeout  time.Duration `json:"read_timeout"`
	WriteTimeout time.Duration `json:"write_timeout"`
}

type DBConfig struct {
	Host            string        `json:"host"`
	Port            int           `json:"port"`
	User            string        `json:"user"`
	Password        string        `json:"password"`
	DBName          string        `json:"db_name"`
	SSLMode         string        `json:"ssl_mode"`
	MaxConns        int32         `json:"max_conns"`
	MinConns        int32         `json:"min_conns"`
	MaxConnLifetime time.Duration `json:"max_conn_lifetime"`
	MaxConnIdleTime time.Duration `json:"max_conn_idle_time"`
	URL             string        `json:"url"`
}

func (c DBConfig) DSN() string {
	if c.URL != "" {
		return c.URL
	}
	return fmt.Sprintf("postgres://%s:%s@%s:%d/%s?sslmode=%s",
		c.User, c.Password, c.Host, c.Port, c.DBName, c.SSLMode)
}

type JWTConfig struct {
	Secret string        `json:"secret"`
	Expiry time.Duration `json:"expiry"`
}

type Config struct {
	App         AppConfig           `json:"app"`
	JWT         JWTConfig           `json:"jwt"`
	DBPrimary   DBConfig            `json:"db_primary"`
	DBSecondary DBConfig            `json:"db_secondary"`
	Databases   map[string]DBConfig `json:"databases"`
}

func LoadConfig() *Config {
	_ = godotenv.Load(".env.local", ".env")

	return &Config{
		App: AppConfig{
			Name:         getEnv("APP_NAME", getEnv("SERVICE_NAME", "test-demo-service")),
			Port:         getEnv("PORT", "8080"),
			Env:          getEnv("APP_ENV", "development"),
			ReadTimeout:  getEnvAsDuration("APP_READ_TIMEOUT", 10*time.Second),
			WriteTimeout: getEnvAsDuration("APP_WRITE_TIMEOUT", 10*time.Second),
		},
		JWT: JWTConfig{
			Secret: getEnv("JWT_SECRET", "super-secret-jwt-key-minimum-32-characters"),
			Expiry: getEnvAsDuration("JWT_EXPIRY", 24*time.Hour),
		},
		DBPrimary: DBConfig{
			Host:            getEnv("DB_PRIMARY_HOST", "localhost"),
			Port:            getEnvAsInt("DB_PRIMARY_PORT", 5432),
			User:            getEnv("DB_PRIMARY_USER", "postgres"),
			Password:        getEnv("DB_PRIMARY_PASSWORD", "password"),
			DBName:          getEnv("DB_PRIMARY_NAME", "app_db"),
			SSLMode:         getEnv("DB_PRIMARY_SSLMODE", "disable"),
			MaxConns:        getEnvAsInt32("DB_PRIMARY_MAX_CONNS", 20),
			MinConns:        getEnvAsInt32("DB_PRIMARY_MIN_CONNS", 5),
			MaxConnLifetime: getEnvAsDuration("DB_PRIMARY_MAX_CONN_LIFETIME", time.Hour),
			MaxConnIdleTime: getEnvAsDuration("DB_PRIMARY_MAX_CONN_IDLE_TIME", 30*time.Minute),
			URL:             getEnv("DATABASE_URL", ""),
		},
		DBSecondary: DBConfig{
			Host:            getEnv("DB_SECONDARY_HOST", "localhost"),
			Port:            getEnvAsInt("DB_SECONDARY_PORT", 5432),
			User:            getEnv("DB_SECONDARY_USER", "postgres"),
			Password:        getEnv("DB_SECONDARY_PASSWORD", "password"),
			DBName:          getEnv("DB_SECONDARY_NAME", "app_db"),
			SSLMode:         getEnv("DB_SECONDARY_SSLMODE", "disable"),
			MaxConns:        getEnvAsInt32("DB_SECONDARY_MAX_CONNS", 20),
			MinConns:        getEnvAsInt32("DB_SECONDARY_MIN_CONNS", 5),
			MaxConnLifetime: getEnvAsDuration("DB_SECONDARY_MAX_CONN_LIFETIME", time.Hour),
			MaxConnIdleTime: getEnvAsDuration("DB_SECONDARY_MAX_CONN_IDLE_TIME", 30*time.Minute),
			URL:             getEnv("DATABASE_SECONDARY_URL", ""),
		},
	}
}

func getEnv(key, defaultVal string) string {
	if val, ok := os.LookupEnv(key); ok && val != "" {
		return val
	}
	return defaultVal
}

func getEnvAsInt(key string, defaultVal int) int {
	valStr := getEnv(key, "")
	if val, err := strconv.Atoi(valStr); err == nil {
		return val
	}
	return defaultVal
}

func getEnvAsInt32(key string, defaultVal int32) int32 {
	valStr := getEnv(key, "")
	if val, err := strconv.ParseInt(valStr, 10, 32); err == nil {
		return int32(val)
	}
	return defaultVal
}

func getEnvAsDuration(key string, defaultVal time.Duration) time.Duration {
	valStr := getEnv(key, "")
	if val, err := time.ParseDuration(valStr); err == nil {
		return val
	}
	return defaultVal
}
