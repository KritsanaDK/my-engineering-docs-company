package logger

type LogLevel string

const (
	LogInfo    LogLevel = "info"
	LogWarning LogLevel = "warn"
	LogError   LogLevel = "error"
	LogDebug   LogLevel = "debug"
)

type LogCallback func(logLevel LogLevel, trackID, message string, args ...interface{})

func DefaultLogCallback(logLevel LogLevel, trackID, message string, args ...interface{}) {
	switch logLevel {
	case LogInfo:
		Info("["+trackID+"] "+message, args...)
	case LogError:
		Error("["+trackID+"] "+message, args...)
	case LogWarning:
		Warn("["+trackID+"] "+message, args...)
	default:
		Debug("["+trackID+"] "+message, args...)
	}
}
