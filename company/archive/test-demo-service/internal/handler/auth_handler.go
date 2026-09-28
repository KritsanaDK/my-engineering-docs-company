package handler

import (
	"net/http"

	"test-demo-service/internal/constant"
	"test-demo-service/internal/middleware"
	"test-demo-service/internal/model"
	"test-demo-service/internal/service"

	"github.com/labstack/echo/v4"
)

type AuthHandler struct {
	*BaseHandler
	userService service.UserService
}

func NewAuthHandler(baseHandler *BaseHandler, userService service.UserService) *AuthHandler {
	return &AuthHandler{
		BaseHandler: baseHandler,
		userService: userService,
	}
}

func (h *AuthHandler) Register(c echo.Context) error {
	tracking := model.NewTracking(c.Path(), c.Request().Method, nil)

	var req model.RegisterRequest
	if err := c.Bind(&req); err != nil {
		return h.GenErrorResponse(c, constant.CodeInvalidParam, "invalid request payload", http.StatusBadRequest, tracking)
	}
	tracking.Request = req

	if err := h.ValidatorParam(req); err != nil {
		return h.GenErrorResponse(c, constant.CodeInvalidParam, err.Error(), http.StatusBadRequest, tracking)
	}

	res, err := h.userService.Register(c.Request().Context(), req)
	if err != nil {
		return h.GenErrorResponse(c, constant.CodeConflict, err.Error(), http.StatusBadRequest, tracking)
	}

	return h.GenCustomResponse(c, res, constant.CodeSuccess, constant.MessageSuccess, http.StatusCreated, tracking)
}

func (h *AuthHandler) Login(c echo.Context) error {
	tracking := model.NewTracking(c.Path(), c.Request().Method, nil)

	var req model.LoginRequest
	if err := c.Bind(&req); err != nil {
		return h.GenErrorResponse(c, constant.CodeInvalidParam, "invalid request payload", http.StatusBadRequest, tracking)
	}
	tracking.Request = req

	if err := h.ValidatorParam(req); err != nil {
		return h.GenErrorResponse(c, constant.CodeInvalidParam, err.Error(), http.StatusBadRequest, tracking)
	}

	res, err := h.userService.Login(c.Request().Context(), req)
	if err != nil {
		return h.GenErrorResponse(c, constant.CodeUnauthorized, err.Error(), http.StatusUnauthorized, tracking)
	}

	return h.GenSuccessResponse(c, res, tracking)
}

func (h *AuthHandler) GetMe(c echo.Context) error {
	tracking := model.NewTracking(c.Path(), c.Request().Method, nil)

	userID, ok := c.Get(middleware.ContextUserIDKey).(string)
	if !ok || userID == "" {
		return h.GenErrorResponse(c, constant.CodeUnauthorized, "unauthorized", http.StatusUnauthorized, tracking)
	}

	profile, err := h.userService.GetProfile(c.Request().Context(), userID)
	if err != nil {
		return h.GenErrorResponse(c, constant.CodeNotFound, err.Error(), http.StatusNotFound, tracking)
	}

	return h.GenSuccessResponse(c, profile, tracking)
}
