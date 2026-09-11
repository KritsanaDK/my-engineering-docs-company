package service

import (
	"context"
	"errors"
	"fmt"
	"time"

	"test-demo-service/internal/config"
	"test-demo-service/internal/model"
	"test-demo-service/internal/repository"

	"github.com/golang-jwt/jwt/v5"
	"github.com/google/uuid"
	"golang.org/x/crypto/bcrypt"
)

type UserService interface {
	Register(ctx context.Context, req model.RegisterRequest) (*model.AuthResponse, error)
	Login(ctx context.Context, req model.LoginRequest) (*model.AuthResponse, error)
	GetProfile(ctx context.Context, userID string) (*model.UserResponse, error)
	CreateUser(ctx context.Context, req model.CreateUserRequest) (*model.UserResponse, error)
	GetUserByID(ctx context.Context, id string) (*model.UserResponse, error)
	ListUsers(ctx context.Context, limit, offset int) (*model.UserListResponse, error)
	ListUsersByPartner(ctx context.Context, partnerID string, limit, offset int) (*model.UserListResponse, error)
	UpdateUser(ctx context.Context, id string, req model.UpdateUserRequest) (*model.UserResponse, error)
	DeleteUser(ctx context.Context, id string) error
}

type userService struct {
	userRepo  repository.UserRepository
	jwtConfig config.JWTConfig
}

func NewUserService(userRepo repository.UserRepository, jwtConfig config.JWTConfig) UserService {
	return &userService{
		userRepo:  userRepo,
		jwtConfig: jwtConfig,
	}
}

func (s *userService) Register(ctx context.Context, req model.RegisterRequest) (*model.AuthResponse, error) {
	if req.Email == "" || req.Password == "" || req.Name == "" {
		return nil, errors.New("email, password, and name are required")
	}

	existing, _ := s.userRepo.GetByEmail(ctx, req.Email)
	if existing != nil {
		return nil, errors.New("email is already registered")
	}

	hash, err := bcrypt.GenerateFromPassword([]byte(req.Password), bcrypt.DefaultCost)
	if err != nil {
		return nil, fmt.Errorf("failed to hash password: %w", err)
	}

	user := &model.User{
		ID:           "usr-" + uuid.New().String()[:8],
		Email:        req.Email,
		PasswordHash: string(hash),
		Name:         req.Name,
		Role:         model.RoleUser,
		PartnerID:    req.PartnerID,
	}

	if err := s.userRepo.Create(ctx, user); err != nil {
		return nil, fmt.Errorf("failed to create user: %w", err)
	}

	token, err := s.generateToken(user)
	if err != nil {
		return nil, fmt.Errorf("failed to generate token: %w", err)
	}

	return &model.AuthResponse{
		Token: token,
		User:  user.ToResponse(),
	}, nil
}

func (s *userService) Login(ctx context.Context, req model.LoginRequest) (*model.AuthResponse, error) {
	if req.Email == "" || req.Password == "" {
		return nil, errors.New("email and password are required")
	}

	user, err := s.userRepo.GetByEmail(ctx, req.Email)
	if err != nil {
		return nil, errors.New("invalid email or password")
	}

	if err := bcrypt.CompareHashAndPassword([]byte(user.PasswordHash), []byte(req.Password)); err != nil {
		return nil, errors.New("invalid email or password")
	}

	token, err := s.generateToken(user)
	if err != nil {
		return nil, fmt.Errorf("failed to generate token: %w", err)
	}

	return &model.AuthResponse{
		Token: token,
		User:  user.ToResponse(),
	}, nil
}

func (s *userService) GetProfile(ctx context.Context, userID string) (*model.UserResponse, error) {
	user, err := s.userRepo.GetByID(ctx, userID)
	if err != nil {
		return nil, err
	}
	return user.ToResponse(), nil
}

func (s *userService) CreateUser(ctx context.Context, req model.CreateUserRequest) (*model.UserResponse, error) {
	if req.Email == "" || req.Password == "" || req.Name == "" {
		return nil, errors.New("email, password, and name are required")
	}

	existing, _ := s.userRepo.GetByEmail(ctx, req.Email)
	if existing != nil {
		return nil, errors.New("email is already registered")
	}

	hash, err := bcrypt.GenerateFromPassword([]byte(req.Password), bcrypt.DefaultCost)
	if err != nil {
		return nil, fmt.Errorf("failed to hash password: %w", err)
	}

	role := req.Role
	if role == "" {
		role = model.RoleUser
	} else if !role.IsValid() {
		return nil, fmt.Errorf("invalid role '%s'", role)
	}

	user := &model.User{
		ID:           "usr-" + uuid.New().String()[:8],
		Email:        req.Email,
		PasswordHash: string(hash),
		Name:         req.Name,
		Role:         role,
		PartnerID:    req.PartnerID,
	}

	if err := s.userRepo.Create(ctx, user); err != nil {
		return nil, err
	}

	return user.ToResponse(), nil
}

func (s *userService) GetUserByID(ctx context.Context, id string) (*model.UserResponse, error) {
	user, err := s.userRepo.GetByID(ctx, id)
	if err != nil {
		return nil, err
	}
	return user.ToResponse(), nil
}

func (s *userService) ListUsers(ctx context.Context, limit, offset int) (*model.UserListResponse, error) {
	if limit <= 0 {
		limit = 10
	}
	if offset < 0 {
		offset = 0
	}

	users, total, err := s.userRepo.List(ctx, limit, offset)
	if err != nil {
		return nil, err
	}

	resUsers := make([]*model.UserResponse, 0, len(users))
	for _, u := range users {
		resUsers = append(resUsers, u.ToResponse())
	}

	return &model.UserListResponse{
		Users:  resUsers,
		Total:  total,
		Limit:  limit,
		Offset: offset,
	}, nil
}

func (s *userService) ListUsersByPartner(ctx context.Context, partnerID string, limit, offset int) (*model.UserListResponse, error) {
	if limit <= 0 {
		limit = 10
	}
	if offset < 0 {
		offset = 0
	}

	users, total, err := s.userRepo.ListByPartner(ctx, partnerID, limit, offset)
	if err != nil {
		return nil, err
	}

	resUsers := make([]*model.UserResponse, 0, len(users))
	for _, u := range users {
		resUsers = append(resUsers, u.ToResponse())
	}

	return &model.UserListResponse{
		Users:  resUsers,
		Total:  total,
		Limit:  limit,
		Offset: offset,
	}, nil
}

func (s *userService) UpdateUser(ctx context.Context, id string, req model.UpdateUserRequest) (*model.UserResponse, error) {
	user, err := s.userRepo.GetByID(ctx, id)
	if err != nil {
		return nil, err
	}

	if req.Email != nil && *req.Email != "" && *req.Email != user.Email {
		existing, _ := s.userRepo.GetByEmail(ctx, *req.Email)
		if existing != nil && existing.ID != id {
			return nil, errors.New("email is already in use by another user")
		}
		user.Email = *req.Email
	}

	if req.Name != nil && *req.Name != "" {
		user.Name = *req.Name
	}

	if req.Role != nil && *req.Role != "" {
		if !req.Role.IsValid() {
			return nil, fmt.Errorf("invalid role '%s'", *req.Role)
		}
		user.Role = *req.Role
	}

	if req.PartnerID != nil {
		user.PartnerID = req.PartnerID
	}

	if req.Password != nil && *req.Password != "" {
		hash, err := bcrypt.GenerateFromPassword([]byte(*req.Password), bcrypt.DefaultCost)
		if err != nil {
			return nil, fmt.Errorf("failed to hash password: %w", err)
		}
		user.PasswordHash = string(hash)
	}

	if err := s.userRepo.Update(ctx, user); err != nil {
		return nil, err
	}

	return user.ToResponse(), nil
}

func (s *userService) DeleteUser(ctx context.Context, id string) error {
	return s.userRepo.Delete(ctx, id)
}

func (s *userService) generateToken(user *model.User) (string, error) {
	claims := &model.JWTCustomClaims{
		UserID:    user.ID,
		Email:     user.Email,
		Role:      user.Role,
		PartnerID: user.PartnerID,
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(time.Now().Add(s.jwtConfig.Expiry)),
			IssuedAt:  jwt.NewNumericDate(time.Now()),
		},
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	return token.SignedString([]byte(s.jwtConfig.Secret))
}
