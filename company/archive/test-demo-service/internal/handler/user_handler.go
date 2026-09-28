package handler

import (
	"net/http"
	"strconv"

	"test-demo-service/internal/constant"
	"test-demo-service/internal/model"
	"test-demo-service/internal/service"

	"github.com/labstack/echo/v4"
)

type UserHandler struct {
	*BaseHandler
	userService service.UserService
}

func NewUserHandler(baseHandler *BaseHandler, userService service.UserService) *UserHandler {
	return &UserHandler{
		BaseHandler: baseHandler,
		userService: userService,
	}
}

func (h *UserHandler) Create(c echo.Context) error {
	tracking := model.NewTracking(c.Path(), c.Request().Method, nil)

	var req model.CreateUserRequest
	if err := c.Bind(&req); err != nil {
		return h.GenErrorResponse(c, constant.CodeInvalidParam, "invalid request payload", http.StatusBadRequest, tracking)
	}
	tracking.Request = req

	if err := h.ValidatorParam(req); err != nil {
		return h.GenErrorResponse(c, constant.CodeInvalidParam, err.Error(), http.StatusBadRequest, tracking)
	}

	user, err := h.userService.CreateUser(c.Request().Context(), req)
	if err != nil {
		return h.GenErrorResponse(c, constant.CodeConflict, err.Error(), http.StatusBadRequest, tracking)
	}

	return h.GenCustomResponse(c, user, constant.CodeSuccess, constant.MessageSuccess, http.StatusCreated, tracking)
}

func (h *UserHandler) GetByID(c echo.Context) error {
	tracking := model.NewTracking(c.Path(), c.Request().Method, nil)
	id := c.Param("id")

	user, err := h.userService.GetUserByID(c.Request().Context(), id)
	if err != nil {
		return h.GenErrorResponse(c, constant.CodeNotFound, err.Error(), http.StatusNotFound, tracking)
	}

	return h.GenSuccessResponse(c, user, tracking)
}

func (h *UserHandler) List(c echo.Context) error {
	tracking := model.NewTracking(c.Path(), c.Request().Method, nil)

	limit, _ := strconv.Atoi(c.QueryParam("limit"))
	offset, _ := strconv.Atoi(c.QueryParam("offset"))

	if limit <= 0 {
		limit = 10
	}
	if offset < 0 {
		offset = 0
	}

	result, err := h.userService.ListUsers(c.Request().Context(), limit, offset)
	if err != nil {
		return h.GenErrorResponse(c, constant.CodeInternalError, err.Error(), http.StatusInternalServerError, tracking)
	}

	return h.GenSuccessResponse(c, result, tracking)
}

func (h *UserHandler) Update(c echo.Context) error {
	tracking := model.NewTracking(c.Path(), c.Request().Method, nil)
	id := c.Param("id")

	var req model.UpdateUserRequest
	if err := c.Bind(&req); err != nil {
		return h.GenErrorResponse(c, constant.CodeInvalidParam, "invalid request payload", http.StatusBadRequest, tracking)
	}
	tracking.Request = req

	user, err := h.userService.UpdateUser(c.Request().Context(), id, req)
	if err != nil {
		return h.GenErrorResponse(c, constant.CodeInvalidParam, err.Error(), http.StatusBadRequest, tracking)
	}

	return h.GenSuccessResponse(c, user, tracking)
}

func (h *UserHandler) Delete(c echo.Context) error {
	tracking := model.NewTracking(c.Path(), c.Request().Method, nil)
	id := c.Param("id")

	if err := h.userService.DeleteUser(c.Request().Context(), id); err != nil {
		return h.GenErrorResponse(c, constant.CodeInternalError, err.Error(), http.StatusInternalServerError, tracking)
	}

	return h.GenSuccessResponse(c, echo.Map{"message": "user deleted successfully"}, tracking)
}
