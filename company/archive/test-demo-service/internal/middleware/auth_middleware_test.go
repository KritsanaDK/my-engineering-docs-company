package middleware_test

import (
	"net/http"
	"net/http/httptest"
	"testing"
	"time"

	appMiddleware "test-demo-service/internal/middleware"
	"test-demo-service/internal/model"

	"github.com/golang-jwt/jwt/v5"
	"github.com/labstack/echo/v4"
)

const testSecret = "my-test-secret-key-32-characters"

func generateTestToken(userID, email string, role model.Role, partnerID *string, expired bool) string {
	exp := time.Now().Add(1 * time.Hour)
	if expired {
		exp = time.Now().Add(-1 * time.Hour)
	}

	claims := &model.JWTCustomClaims{
		UserID:    userID,
		Email:     email,
		Role:      role,
		PartnerID: partnerID,
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(exp),
			IssuedAt:  jwt.NewNumericDate(time.Now()),
		},
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	tokenStr, _ := token.SignedString([]byte(testSecret))
	return tokenStr
}

func TestJWTAuthMiddleware(t *testing.T) {
	e := echo.New()

	t.Run("Valid Token", func(t *testing.T) {
		token := generateTestToken("usr-1", "user@example.com", model.RoleAdmin, nil, false)
		req := httptest.NewRequest(http.MethodGet, "/protected", nil)
		req.Header.Set("Authorization", "Bearer "+token)
		rec := httptest.NewRecorder()
		c := e.NewContext(req, rec)

		mw := appMiddleware.JWTAuthMiddleware(testSecret)
		handler := mw(func(c echo.Context) error {
			return c.String(http.StatusOK, "ok")
		})

		if err := handler(c); err != nil {
			t.Fatalf("unexpected error: %v", err)
		}
	})

	t.Run("Missing Auth Header", func(t *testing.T) {
		req := httptest.NewRequest(http.MethodGet, "/protected", nil)
		rec := httptest.NewRecorder()
		c := e.NewContext(req, rec)

		mw := appMiddleware.JWTAuthMiddleware(testSecret)
		handler := mw(func(c echo.Context) error {
			return c.String(http.StatusOK, "ok")
		})

		err := handler(c)
		if err == nil {
			t.Errorf("expected error for missing auth header")
		}
	})
}

func TestRequireRole(t *testing.T) {
	e := echo.New()

	t.Run("Allowed Role", func(t *testing.T) {
		req := httptest.NewRequest(http.MethodGet, "/admin", nil)
		rec := httptest.NewRecorder()
		c := e.NewContext(req, rec)
		c.Set(appMiddleware.ContextRoleKey, model.RoleAdmin)

		guard := appMiddleware.RequireRole(model.RoleAdmin, model.RoleSuperAdmin)
		handler := guard(func(c echo.Context) error {
			return c.String(http.StatusOK, "welcome")
		})

		if err := handler(c); err != nil {
			t.Fatalf("unexpected error: %v", err)
		}
	})
}
