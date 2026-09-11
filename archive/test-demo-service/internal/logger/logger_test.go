package logger_test

import (
	"testing"
	"time"

	"test-demo-service/internal/logger"
	"test-demo-service/internal/model"

	"go.uber.org/zap"
)

func TestLogger_System(t *testing.T) {
	if err := logger.InitializeLoggerSystem(); err != nil {
		t.Fatalf("failed to initialize logger: %v", err)
	}
	defer logger.Sync()

	logger.Info("testing info message: %s", "hello")
	logger.Warn("testing warn message")
	logger.Debug("testing debug message")
	logger.Error("testing error message")
	logger.Trace("testing trace message")

	logger.InfoWithFields("testing info with fields", zap.String("key", "val"))
	logger.WarnWithFields("testing warn with fields", zap.Int("code", 400))
	logger.ErrorWithFields("testing error with fields", zap.String("reason", "failed"))
	logger.DebugWithFields("testing debug with fields", zap.Bool("active", true))
	logger.TraceWithFields("testing trace with fields", zap.Float64("pi", 3.14))

	tracking := &model.Tracking{
		Track:     "trk-12345",
		URI:       "/api/v1/test",
		Method:    "POST",
		Request:   map[string]string{"foo": "bar"},
		Response:  map[string]string{"status": "ok"},
		StartDate: time.Now().Add(-100 * time.Millisecond),
	}

	logger.InfoWithTracking("handler tracking", tracking)
	logger.WarnWithTracking("warn tracking", tracking)
	logger.DebugWithTracking("debug tracking", tracking)
	logger.ErrorWithTracking("error tracking", "something went wrong", tracking)
	logger.TraceWithTracking("trace tracking", tracking)

	sugar := logger.GetSugar()
	if sugar != nil {
		logger.LogInfoQueue("Queue message", "payload processed", sugar, tracking)
		logger.LogErrorQueue("Queue error", "failed processing", sugar, tracking)
	}

	logger.DefaultLogCallback(logger.LogInfo, "trk-1", "callback info message")
	logger.DefaultLogCallback(logger.LogError, "trk-1", "callback error message")
	logger.DefaultLogCallback(logger.LogWarning, "trk-1", "callback warn message")
	logger.DefaultLogCallback(logger.LogDebug, "trk-1", "callback debug message")
}
