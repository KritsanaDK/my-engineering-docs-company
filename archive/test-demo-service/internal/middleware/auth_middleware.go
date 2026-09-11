package middleware

import (
	"errors"
	"net/http"
	"strings"

	"test-demo-service/internal/model"

	"github.com/golang-jwt/jwt/v5"
	"github.com/labstack/echo/v4"
)

const (
	ContextUserIDKey    = "user_id"
	ContextEmailKey     = "email"
	ContextRoleKey      = "role"
	ContextPartnerIDKey = "partner_id"
)

func JWTAuthMiddleware(jwtSecret string) echo.MiddlewareFunc {
	return func(next echo.HandlerFunc) echo.HandlerFunc {
		return func(c echo.Context) error {
			authHeader := c.Request().Header.Get("Authorization")
			if authHeader == "" {
				return echo.NewHTTPError(http.StatusUnauthorized, "missing authorization header")
			}

			parts := strings.Split(authHeader, " ")
			if len(parts) != 2 || strings.ToLower(parts[0]) != "bearer" {
				return echo.NewHTTPError(http.StatusUnauthorized, "invalid authorization format, expected 'Bearer <token>'")
			}

			tokenString := parts[1]

			token, err := jwt.ParseWithClaims(tokenString, &model.JWTCustomClaims{}, func(t *jwt.Token) (interface{}, error) {
				if _, ok := t.Method.(*jwt.SigningMethodHMAC); !ok {
					return nil, errors.New("unexpected signing method")
				}
				return []byte(jwtSecret), nil
			})

			if err != nil || !token.Valid {
				return echo.NewHTTPError(http.StatusUnauthorized, "invalid or expired token")
			}

			claims, ok := token.Claims.(*model.JWTCustomClaims)
			if !ok {
				return echo.NewHTTPError(http.StatusUnauthorized, "invalid token claims")
			}

			c.Set(ContextUserIDKey, claims.UserID)
			c.Set(ContextEmailKey, claims.Email)
			c.Set(ContextRoleKey, claims.Role)
			if claims.PartnerID != nil {
				c.Set(ContextPartnerIDKey, *claims.PartnerID)
			}

			return next(c)
		}
	}
}

func RequireRole(allowedRoles ...model.Role) echo.MiddlewareFunc {
	allowedMap := make(map[model.Role]struct{}, len(allowedRoles))
	for _, r := range allowedRoles {
		allowedMap[r] = struct{}{}
	}

	return func(next echo.HandlerFunc) echo.HandlerFunc {
		return func(c echo.Context) error {
			roleVal := c.Get(ContextRoleKey)
			userRole, ok := roleVal.(model.Role)
			if !ok {
				if strRole, isStr := roleVal.(string); isStr {
					userRole = model.Role(strRole)
				} else {
					return echo.NewHTTPError(http.StatusForbidden, "access denied: missing role")
				}
			}

			if _, exists := allowedMap[userRole]; !exists {
				return echo.NewHTTPError(http.StatusForbidden, "access denied: insufficient permissions")
			}

			return next(c)
		}
	}
}

func RequireMinRole(minRole model.Role) echo.MiddlewareFunc {
	return func(next echo.HandlerFunc) echo.HandlerFunc {
		return func(c echo.Context) error {
			roleVal := c.Get(ContextRoleKey)
			userRole, ok := roleVal.(model.Role)
			if !ok {
				if strRole, isStr := roleVal.(string); isStr {
					userRole = model.Role(strRole)
				} else {
					return echo.NewHTTPError(http.StatusForbidden, "access denied: missing role")
				}
			}

			if !userRole.CanManage(minRole) {
				return echo.NewHTTPError(http.StatusForbidden, "access denied: insufficient role level")
			}

			return next(c)
		}
	}
}

func RequireThirdPartyPartner() echo.MiddlewareFunc {
	return func(next echo.HandlerFunc) echo.HandlerFunc {
		return func(c echo.Context) error {
			roleVal := c.Get(ContextRoleKey)
			userRole, ok := roleVal.(model.Role)
			if !ok {
				if strRole, isStr := roleVal.(string); isStr {
					userRole = model.Role(strRole)
				} else {
					return echo.NewHTTPError(http.StatusForbidden, "access denied: missing role")
				}
			}

			if !userRole.IsThirdParty() && userRole != model.RoleSuperAdmin && userRole != model.RoleAdmin {
				return echo.NewHTTPError(http.StatusForbidden, "access denied: third-party partner access required")
			}

			return next(c)
		}
	}
}
