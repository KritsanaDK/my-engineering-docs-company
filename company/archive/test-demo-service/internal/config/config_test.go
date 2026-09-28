package config_test

import (
	"os"
	"testing"
	"time"

	"test-demo-service/internal/config"
)

func TestLoadConfig_Defaults(t *testing.T) {
	os.Unsetenv("PORT")
	os.Unsetenv("APP_NAME")

	cfg := config.LoadConfig()
	if cfg.App.Port == "" {
		t.Errorf("expected non-empty default port")
	}
	if cfg.JWT.Secret == "" {
		t.Errorf("expected non-empty default JWT secret")
	}
	if cfg.App.ReadTimeout != 10*time.Second {
		t.Errorf("expected 10s default read timeout, got %v", cfg.App.ReadTimeout)
	}
}

func TestDBConfig_DSN(t *testing.T) {
	dbCfg := config.DBConfig{
		Host:     "localhost",
		Port:     5432,
		User:     "myuser",
		Password: "mypassword",
		DBName:   "mydb",
		SSLMode:  "disable",
	}

	expected := "postgres://myuser:mypassword@localhost:5432/mydb?sslmode=disable"
	if dsn := dbCfg.DSN(); dsn != expected {
		t.Errorf("DBConfig.DSN() = %s, want %s", dsn, expected)
	}

	dbCfg.URL = "postgres://custom-url:5432/db"
	if dsn := dbCfg.DSN(); dsn != dbCfg.URL {
		t.Errorf("DBConfig.DSN() with URL = %s, want %s", dsn, dbCfg.URL)
	}
}
