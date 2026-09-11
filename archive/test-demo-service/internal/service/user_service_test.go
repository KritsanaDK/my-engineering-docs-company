package service_test

import (
	"context"
	"errors"
	"testing"
	"time"

	"test-demo-service/internal/config"
	"test-demo-service/internal/model"
	"test-demo-service/internal/service"
)

type MockUserRepository struct {
	users map[string]*model.User
}

func NewMockUserRepo() *MockUserRepository {
	return &MockUserRepository{users: make(map[string]*model.User)}
}

func (m *MockUserRepository) Create(ctx context.Context, user *model.User) error {
	for _, u := range m.users {
		if u.Email == user.Email {
			return errors.New("duplicate email")
		}
	}
	m.users[user.ID] = user
	return nil
}

func (m *MockUserRepository) GetByID(ctx context.Context, id string) (*model.User, error) {
	if u, ok := m.users[id]; ok {
		return u, nil
	}
	return nil, errors.New("user not found")
}

func (m *MockUserRepository) GetByEmail(ctx context.Context, email string) (*model.User, error) {
	for _, u := range m.users {
		if u.Email == email {
			return u, nil
		}
	}
	return nil, errors.New("user not found")
}

func (m *MockUserRepository) List(ctx context.Context, limit, offset int) ([]*model.User, int64, error) {
	var list []*model.User
	for _, u := range m.users {
		list = append(list, u)
	}
	return list, int64(len(list)), nil
}

func (m *MockUserRepository) ListByPartner(ctx context.Context, partnerID string, limit, offset int) ([]*model.User, int64, error) {
	var list []*model.User
	for _, u := range m.users {
		if u.PartnerID != nil && *u.PartnerID == partnerID {
			list = append(list, u)
		}
	}
	return list, int64(len(list)), nil
}

func (m *MockUserRepository) Update(ctx context.Context, user *model.User) error {
	if _, ok := m.users[user.ID]; !ok {
		return errors.New("user not found")
	}
	m.users[user.ID] = user
	return nil
}

func (m *MockUserRepository) Delete(ctx context.Context, id string) error {
	if _, ok := m.users[id]; !ok {
		return errors.New("user not found")
	}
	delete(m.users, id)
	return nil
}

func TestUserService_RegisterAndLogin(t *testing.T) {
	mockRepo := NewMockUserRepo()
	jwtCfg := config.JWTConfig{
		Secret: "test-secret-key-for-unit-testing",
		Expiry: 1 * time.Hour,
	}

	userService := service.NewUserService(mockRepo, jwtCfg)
	ctx := context.Background()

	regReq := model.RegisterRequest{
		Email:    "test@example.com",
		Password: "password123",
		Name:     "Test User",
	}

	authRes, err := userService.Register(ctx, regReq)
	if err != nil {
		t.Fatalf("expected register success, got: %v", err)
	}
	if authRes.Token == "" {
		t.Errorf("expected non-empty token")
	}

	_, err = userService.Register(ctx, regReq)
	if err == nil {
		t.Errorf("expected error on duplicate email registration")
	}

	loginReq := model.LoginRequest{
		Email:    "test@example.com",
		Password: "password123",
	}
	loginRes, err := userService.Login(ctx, loginReq)
	if err != nil {
		t.Fatalf("expected login success, got: %v", err)
	}
	if loginRes.Token == "" {
		t.Errorf("expected non-empty login token")
	}

	wrongLoginReq := model.LoginRequest{
		Email:    "test@example.com",
		Password: "wrongpassword",
	}
	_, err = userService.Login(ctx, wrongLoginReq)
	if err == nil {
		t.Errorf("expected error on wrong password")
	}
}

func TestUserService_UserCRUD(t *testing.T) {
	mockRepo := NewMockUserRepo()
	jwtCfg := config.JWTConfig{
		Secret: "test-secret-key",
		Expiry: 1 * time.Hour,
	}

	userService := service.NewUserService(mockRepo, jwtCfg)
	ctx := context.Background()

	createReq := model.CreateUserRequest{
		Email:    "manager@example.com",
		Password: "secretpassword",
		Name:     "Manager",
		Role:     model.RoleAdmin,
	}
	createdUser, err := userService.CreateUser(ctx, createReq)
	if err != nil {
		t.Fatalf("expected create user success, got: %v", err)
	}

	fetchedUser, err := userService.GetUserByID(ctx, createdUser.ID)
	if err != nil {
		t.Fatalf("expected get user success, got: %v", err)
	}
	if fetchedUser.Email != createReq.Email {
		t.Errorf("expected email %s, got %s", createReq.Email, fetchedUser.Email)
	}

	newName := "Updated Manager"
	newRole := model.RoleSuperAdmin
	updatedUser, err := userService.UpdateUser(ctx, createdUser.ID, model.UpdateUserRequest{
		Name: &newName,
		Role: &newRole,
	})
	if err != nil {
		t.Fatalf("expected update user success, got: %v", err)
	}
	if updatedUser.Role != model.RoleSuperAdmin {
		t.Errorf("expected role super_admin, got %s", updatedUser.Role)
	}

	if err := userService.DeleteUser(ctx, createdUser.ID); err != nil {
		t.Fatalf("expected delete user success, got: %v", err)
	}
}
