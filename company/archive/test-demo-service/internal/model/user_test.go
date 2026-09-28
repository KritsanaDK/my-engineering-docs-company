package model_test

import (
	"testing"
	"time"

	"test-demo-service/internal/model"
)

func TestRole_Methods(t *testing.T) {
	tests := []struct {
		name         string
		role         model.Role
		isValid      bool
		level        int
		isThirdParty bool
	}{
		{name: "SuperAdmin Role", role: model.RoleSuperAdmin, isValid: true, level: 50, isThirdParty: false},
		{name: "Admin Role", role: model.RoleAdmin, isValid: true, level: 40, isThirdParty: false},
		{name: "Manager Role", role: model.RoleManager, isValid: true, level: 30, isThirdParty: false},
		{name: "Auditor Role", role: model.RoleAuditor, isValid: true, level: 25, isThirdParty: false},
		{name: "Partner Role", role: model.RolePartner, isValid: true, level: 20, isThirdParty: true},
		{name: "User Role", role: model.RoleUser, isValid: true, level: 10, isThirdParty: false},
		{name: "Invalid Role", role: model.Role("unknown_role"), isValid: false, level: 0, isThirdParty: false},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := tt.role.IsValid(); got != tt.isValid {
				t.Errorf("Role.IsValid() = %v, want %v", got, tt.isValid)
			}
			if got := tt.role.Level(); got != tt.level {
				t.Errorf("Role.Level() = %v, want %v", got, tt.level)
			}
			if got := tt.role.IsThirdParty(); got != tt.isThirdParty {
				t.Errorf("Role.IsThirdParty() = %v, want %v", got, tt.isThirdParty)
			}
		})
	}
}

func TestRole_CanManage(t *testing.T) {
	if !model.RoleSuperAdmin.CanManage(model.RoleAdmin) {
		t.Errorf("expected SuperAdmin to manage Admin")
	}
	if model.RoleUser.CanManage(model.RoleAdmin) {
		t.Errorf("expected User NOT to manage Admin")
	}
}

func TestParseRole(t *testing.T) {
	role, err := model.ParseRole("  ADMIN ")
	if err != nil || role != model.RoleAdmin {
		t.Errorf("expected RoleAdmin, got %v, err: %v", role, err)
	}
	_, err = model.ParseRole("invalid_role")
	if err == nil {
		t.Errorf("expected error for invalid role parsing")
	}
}

func TestUser_ToResponse(t *testing.T) {
	partnerID := "part-01"
	now := time.Now()
	user := &model.User{
		ID:           "usr-1",
		Email:        "test@example.com",
		PasswordHash: "hashed_password",
		Name:         "Test User",
		Role:         model.RoleAdmin,
		PartnerID:    &partnerID,
		CreatedAt:    now,
		UpdatedAt:    now,
	}

	res := user.ToResponse()
	if res.ID != user.ID || res.Email != user.Email || res.Name != user.Name || res.Role != user.Role || *res.PartnerID != partnerID {
		t.Errorf("User.ToResponse() did not map fields correctly")
	}
}
