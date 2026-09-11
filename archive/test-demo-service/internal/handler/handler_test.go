package handler_test

import (
	"bytes"
	"context"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"
	"time"

	"test-demo-service/internal/config"
	"test-demo-service/internal/constant"
	"test-demo-service/internal/handler"
	"test-demo-service/internal/middleware"
	"test-demo-service/internal/model"

	"github.com/labstack/echo/v4"
)

type MockUserService struct {
	registerFunc func(ctx context.Context, req model.RegisterRequest) (*model.AuthResponse, error)
	loginFunc    func(ctx context.Context, req model.LoginRequest) (*model.AuthResponse, error)
	getProfFunc  func(ctx context.Context, userID string) (*model.UserResponse, error)
	createFunc   func(ctx context.Context, req model.CreateUserRequest) (*model.UserResponse, error)
	getByIDFunc  func(ctx context.Context, id string) (*model.UserResponse, error)
	listFunc     func(ctx context.Context, limit, offset int) (*model.UserListResponse, error)
	updateFunc   func(ctx context.Context, id string, req model.UpdateUserRequest) (*model.UserResponse, error)
	deleteFunc   func(ctx context.Context, id string) error
}

func (m *MockUserService) Register(ctx context.Context, req model.RegisterRequest) (*model.AuthResponse, error) {
	if m.registerFunc != nil {
		return m.registerFunc(ctx, req)
	}
	return nil, nil
}
func (m *MockUserService) Login(ctx context.Context, req model.LoginRequest) (*model.AuthResponse, error) {
	if m.loginFunc != nil {
		return m.loginFunc(ctx, req)
	}
	return nil, nil
}
func (m *MockUserService) GetProfile(ctx context.Context, userID string) (*model.UserResponse, error) {
	if m.getProfFunc != nil {
		return m.getProfFunc(ctx, userID)
	}
	return nil, nil
}
func (m *MockUserService) CreateUser(ctx context.Context, req model.CreateUserRequest) (*model.UserResponse, error) {
	if m.createFunc != nil {
		return m.createFunc(ctx, req)
	}
	return nil, nil
}
func (m *MockUserService) GetUserByID(ctx context.Context, id string) (*model.UserResponse, error) {
	if m.getByIDFunc != nil {
		return m.getByIDFunc(ctx, id)
	}
	return nil, nil
}
func (m *MockUserService) ListUsers(ctx context.Context, limit, offset int) (*model.UserListResponse, error) {
	if m.listFunc != nil {
		return m.listFunc(ctx, limit, offset)
	}
	return nil, nil
}
func (m *MockUserService) ListUsersByPartner(ctx context.Context, partnerID string, limit, offset int) (*model.UserListResponse, error) {
	return nil, nil
}
func (m *MockUserService) UpdateUser(ctx context.Context, id string, req model.UpdateUserRequest) (*model.UserResponse, error) {
	if m.updateFunc != nil {
		return m.updateFunc(ctx, id, req)
	}
	return nil, nil
}
func (m *MockUserService) DeleteUser(ctx context.Context, id string) error {
	if m.deleteFunc != nil {
		return m.deleteFunc(ctx, id)
	}
	return nil
}

func TestBaseHandler_ValidatorParam(t *testing.T) {
	cfg := &config.Config{App: config.AppConfig{Name: "test-app", Env: "test"}}
	base := handler.NewBaseHandler(cfg, nil)

	type SampleRequest struct {
		Email string `json:"email" validate:"required,email"`
		Name  string `json:"name" validate:"required"`
	}

	validReq := SampleRequest{Email: "admin@example.com", Name: "Admin"}
	if err := base.ValidatorParam(validReq); err != nil {
		t.Errorf("expected valid, got err: %v", err)
	}
}

func TestAuthHandler_RegisterAndLogin(t *testing.T) {
	cfg := &config.Config{App: config.AppConfig{Name: "test", Env: "test"}}
	base := handler.NewBaseHandler(cfg, nil)
	mockSvc := &MockUserService{
		registerFunc: func(ctx context.Context, req model.RegisterRequest) (*model.AuthResponse, error) {
			return &model.AuthResponse{
				Token: "jwt-token-123",
				User: &model.UserResponse{
					ID:        "usr-1",
					Email:     req.Email,
					Name:      req.Name,
					Role:      model.RoleUser,
					CreatedAt: time.Now(),
					UpdatedAt: time.Now(),
				},
			}, nil
		},
		loginFunc: func(ctx context.Context, req model.LoginRequest) (*model.AuthResponse, error) {
			return &model.AuthResponse{
				Token: "jwt-token-456",
				User: &model.UserResponse{
					ID:    "usr-1",
					Email: req.Email,
					Name:  "User",
					Role:  model.RoleUser,
				},
			}, nil
		},
	}

	authHandler := handler.NewAuthHandler(base, mockSvc)
	e := echo.New()

	regBody, _ := json.Marshal(model.RegisterRequest{
		Email:    "test@example.com",
		Password: "password123",
		Name:     "Test User",
	})
	req := httptest.NewRequest(http.MethodPost, "/api/v1/auth/register", bytes.NewReader(regBody))
	req.Header.Set(echo.HeaderContentType, echo.MIMEApplicationJSON)
	rec := httptest.NewRecorder()
	c := e.NewContext(req, rec)

	if err := authHandler.Register(c); err != nil {
		t.Fatalf("unexpected register error: %v", err)
	}
	if rec.Code != http.StatusCreated {
		t.Errorf("expected status 201 Created, got %d", rec.Code)
	}
}

func TestAuthHandler_GetMe(t *testing.T) {
	cfg := &config.Config{App: config.AppConfig{Name: "test", Env: "test"}}
	base := handler.NewBaseHandler(cfg, nil)
	mockSvc := &MockUserService{
		getProfFunc: func(ctx context.Context, userID string) (*model.UserResponse, error) {
			return &model.UserResponse{
				ID:    userID,
				Email: "me@example.com",
				Name:  "My Name",
				Role:  model.RoleAdmin,
			}, nil
		},
	}

	authHandler := handler.NewAuthHandler(base, mockSvc)
	e := echo.New()

	req := httptest.NewRequest(http.MethodGet, "/api/v1/auth/me", nil)
	rec := httptest.NewRecorder()
	c := e.NewContext(req, rec)
	c.Set(middleware.ContextUserIDKey, "usr-999")

	if err := authHandler.GetMe(c); err != nil {
		t.Fatalf("unexpected GetMe error: %v", err)
	}
	if rec.Code != http.StatusOK {
		t.Errorf("expected 200, got %d", rec.Code)
	}
}

func TestUserHandler_CRUD(t *testing.T) {
	cfg := &config.Config{App: config.AppConfig{Name: "test", Env: "test"}}
	base := handler.NewBaseHandler(cfg, nil)
	mockSvc := &MockUserService{
		createFunc: func(ctx context.Context, req model.CreateUserRequest) (*model.UserResponse, error) {
			return &model.UserResponse{
				ID:    "usr-new",
				Email: req.Email,
				Name:  req.Name,
				Role:  req.Role,
			}, nil
		},
		deleteFunc: func(ctx context.Context, id string) error {
			return nil
		},
	}

	userHandler := handler.NewUserHandler(base, mockSvc)
	e := echo.New()

	req := httptest.NewRequest(http.MethodDelete, "/api/v1/users/usr-new", nil)
	rec := httptest.NewRecorder()
	c := e.NewContext(req, rec)
	c.SetParamNames("id")
	c.SetParamValues("usr-new")

	if err := userHandler.Delete(c); err != nil {
		t.Fatalf("unexpected Delete error: %v", err)
	}
	if rec.Code != http.StatusOK {
		t.Errorf("expected 200 OK, got %d", rec.Code)
	}

	var res model.TemplateResponse
	_ = json.Unmarshal(rec.Body.Bytes(), &res)
	if res.Code != constant.CodeSuccess {
		t.Errorf("expected template response code 0000, got %s", res.Code)
	}
}
