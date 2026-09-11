package constant

const (
	// Success Codes
	CodeSuccess    = "0000"
	MessageSuccess = "SUCCESS"

	// Client Error Codes
	CodeInvalidParam     = "4000"
	MessageInvalidParam  = "INVALID_PARAMETER"
	CodeUnauthorized     = "4001"
	MessageUnauthorized  = "UNAUTHORIZED"
	CodeForbidden        = "4003"
	MessageForbidden     = "FORBIDDEN"
	CodeNotFound         = "4004"
	MessageNotFound      = "NOT_FOUND"
	CodeConflict         = "4009"
	MessageConflict      = "DATA_ALREADY_EXISTS"

	// Server Error Codes
	CodeInternalError    = "5000"
	MessageInternalError = "INTERNAL_SERVER_ERROR"
)
