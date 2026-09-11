package model

import (
	"errors"
	"strings"
	"time"

	"github.com/golang-jwt/jwt/v5"
)

type Role string

const (
	RoleSuperAdmin     Role = "super_admin"
	RoleAdmin          Role = "admin"
	RoleManager        Role = "manager"
	RoleUser           Role = "user"
	RoleAuditor        Role = "auditor"
	RolePartner        Role = "partner"
	RoleVendor         Role = "vendor"
	RoleServiceAccount Role = "service_account"
)

var validRoles = map[Role]struct{}{
	RoleSuperAdmin:     {},
	RoleAdmin:          {},
	RoleManager:        {},
	RoleUser:           {},
	RoleAuditor:        {},
	RolePartner:        {},
	RoleVendor:         {},
	RoleServiceAccount: {},
}

func (r Role) IsValid() bool {
	_, ok := validRoles[r]
	return ok
}

func (r Role) Level() int {
	switch r {
	case RoleSuperAdmin:
		return 50
	case RoleAdmin:
		return 40
	case RoleManager:
		return 30
	case RoleAuditor:
		return 25
	case RolePartner, RoleVendor, RoleServiceAccount:
		return 20
	case RoleUser:
		return 10
	default:
		return 0
	}
}

func (r Role) CanManage(target Role) bool {
	return r.Level() >= target.Level()
}

func (r Role) IsThirdParty() bool {
	return r == RolePartner || r == RoleVendor || r == RoleServiceAccount
}

func ParseRole(s string) (Role, error) {
	normalized := Role(strings.ToLower(strings.TrimSpace(s)))
	if !normalized.IsValid() {
		return "", errors.New("invalid user role")
	}
	return normalized, nil
}

type User struct {
	ID           string    `json:"id"`
	Email        string    `json:"email"`
	PasswordHash string    `json:"-"`
	Name         string    `json:"name"`
	Role         Role      `json:"role"`
	PartnerID    *string   `json:"partner_id,omitempty"`
	CreatedAt    time.Time `json:"created_at"`
	UpdatedAt    time.Time `json:"updated_at"`
}

func (u *User) ToResponse() *UserResponse {
	return &UserResponse{
		ID:        u.ID,
		Email:     u.Email,
		Name:      u.Name,
		Role:      u.Role,
		PartnerID: u.PartnerID,
		CreatedAt: u.CreatedAt,
		UpdatedAt: u.UpdatedAt,
	}
}

type JWTCustomClaims struct {
	UserID    string  `json:"user_id"`
	Email     string  `json:"email"`
	Role      Role    `json:"role"`
	PartnerID *string `json:"partner_id,omitempty"`
	jwt.RegisteredClaims
}

type RegisterRequest struct {
	Email     string  `json:"email" validate:"required,email"`
	Password  string  `json:"password" validate:"required,min=6"`
	Name      string  `json:"name" validate:"required"`
	PartnerID *string `json:"partner_id,omitempty"`
}

type LoginRequest struct {
	Email    string `json:"email" validate:"required,email"`
	Password string `json:"password" validate:"required"`
}

type AuthResponse struct {
	Token string        `json:"token"`
	User  *UserResponse `json:"user"`
}

type CreateUserRequest struct {
	Email     string  `json:"email" validate:"required,email"`
	Password  string  `json:"password" validate:"required,min=6"`
	Name      string  `json:"name" validate:"required"`
	Role      Role    `json:"role,omitempty"`
	PartnerID *string `json:"partner_id,omitempty"`
}

type UpdateUserRequest struct {
	Email     *string `json:"email,omitempty" validate:"omitempty,email"`
	Name      *string `json:"name,omitempty"`
	Role      *Role   `json:"role,omitempty"`
	Password  *string `json:"password,omitempty" validate:"omitempty,min=6"`
	PartnerID *string `json:"partner_id,omitempty"`
}

type UserResponse struct {
	ID        string    `json:"id"`
	Email     string    `json:"email"`
	Name      string    `json:"name"`
	Role      Role      `json:"role"`
	PartnerID *string   `json:"partner_id,omitempty"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

type UserListResponse struct {
	Users  []*UserResponse `json:"users"`
	Total  int64           `json:"total"`
	Limit  int             `json:"limit"`
	Offset int             `json:"offset"`
}
