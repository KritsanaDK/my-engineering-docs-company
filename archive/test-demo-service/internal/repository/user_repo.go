package repository

import (
	"context"
	"errors"
	"time"

	"test-demo-service/internal/model"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
)

type UserRepository interface {
	Create(ctx context.Context, user *model.User) error
	GetByID(ctx context.Context, id string) (*model.User, error)
	GetByEmail(ctx context.Context, email string) (*model.User, error)
	List(ctx context.Context, limit, offset int) ([]*model.User, int64, error)
	ListByPartner(ctx context.Context, partnerID string, limit, offset int) ([]*model.User, int64, error)
	Update(ctx context.Context, user *model.User) error
	Delete(ctx context.Context, id string) error
}

type userRepo struct {
	pool *pgxpool.Pool
}

func NewUserRepo(pool *pgxpool.Pool) UserRepository {
	return &userRepo{pool: pool}
}

func (r *userRepo) Create(ctx context.Context, user *model.User) error {
	runner := GetRunner(ctx, r.pool)
	query := `
		INSERT INTO users (id, email, password_hash, name, role, partner_id, created_at, updated_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
	`
	now := time.Now().UTC()
	user.CreatedAt = now
	user.UpdatedAt = now
	if user.Role == "" {
		user.Role = model.RoleUser
	}

	_, err := runner.Exec(ctx, query, user.ID, user.Email, user.PasswordHash, user.Name, user.Role, user.PartnerID, user.CreatedAt, user.UpdatedAt)
	return err
}

func (r *userRepo) GetByID(ctx context.Context, id string) (*model.User, error) {
	runner := GetRunner(ctx, r.pool)
	query := `SELECT id, email, password_hash, name, role, partner_id, created_at, updated_at FROM users WHERE id = $1`
	row := runner.QueryRow(ctx, query, id)

	var u model.User
	if err := row.Scan(&u.ID, &u.Email, &u.PasswordHash, &u.Name, &u.Role, &u.PartnerID, &u.CreatedAt, &u.UpdatedAt); err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, errors.New("user not found")
		}
		return nil, err
	}
	return &u, nil
}

func (r *userRepo) GetByEmail(ctx context.Context, email string) (*model.User, error) {
	runner := GetRunner(ctx, r.pool)
	query := `SELECT id, email, password_hash, name, role, partner_id, created_at, updated_at FROM users WHERE email = $1`
	row := runner.QueryRow(ctx, query, email)

	var u model.User
	if err := row.Scan(&u.ID, &u.Email, &u.PasswordHash, &u.Name, &u.Role, &u.PartnerID, &u.CreatedAt, &u.UpdatedAt); err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, errors.New("user not found")
		}
		return nil, err
	}
	return &u, nil
}

func (r *userRepo) List(ctx context.Context, limit, offset int) ([]*model.User, int64, error) {
	runner := GetRunner(ctx, r.pool)

	var total int64
	countQuery := `SELECT COUNT(*) FROM users`
	if err := runner.QueryRow(ctx, countQuery).Scan(&total); err != nil {
		return nil, 0, err
	}

	query := `
		SELECT id, email, password_hash, name, role, partner_id, created_at, updated_at 
		FROM users 
		ORDER BY created_at DESC 
		LIMIT $1 OFFSET $2
	`
	rows, err := runner.Query(ctx, query, limit, offset)
	if err != nil {
		return nil, 0, err
	}
	defer rows.Close()

	var users []*model.User
	for rows.Next() {
		var u model.User
		if err := rows.Scan(&u.ID, &u.Email, &u.PasswordHash, &u.Name, &u.Role, &u.PartnerID, &u.CreatedAt, &u.UpdatedAt); err != nil {
			return nil, 0, err
		}
		users = append(users, &u)
	}

	return users, total, rows.Err()
}

func (r *userRepo) ListByPartner(ctx context.Context, partnerID string, limit, offset int) ([]*model.User, int64, error) {
	runner := GetRunner(ctx, r.pool)

	var total int64
	countQuery := `SELECT COUNT(*) FROM users WHERE partner_id = $1`
	if err := runner.QueryRow(ctx, countQuery, partnerID).Scan(&total); err != nil {
		return nil, 0, err
	}

	query := `
		SELECT id, email, password_hash, name, role, partner_id, created_at, updated_at 
		FROM users 
		WHERE partner_id = $1
		ORDER BY created_at DESC 
		LIMIT $2 OFFSET $3
	`
	rows, err := runner.Query(ctx, query, partnerID, limit, offset)
	if err != nil {
		return nil, 0, err
	}
	defer rows.Close()

	var users []*model.User
	for rows.Next() {
		var u model.User
		if err := rows.Scan(&u.ID, &u.Email, &u.PasswordHash, &u.Name, &u.Role, &u.PartnerID, &u.CreatedAt, &u.UpdatedAt); err != nil {
			return nil, 0, err
		}
		users = append(users, &u)
	}

	return users, total, rows.Err()
}

func (r *userRepo) Update(ctx context.Context, user *model.User) error {
	runner := GetRunner(ctx, r.pool)
	query := `
		UPDATE users 
		SET email = $1, password_hash = $2, name = $3, role = $4, partner_id = $5, updated_at = $6 
		WHERE id = $7
	`
	user.UpdatedAt = time.Now().UTC()
	tag, err := runner.Exec(ctx, query, user.Email, user.PasswordHash, user.Name, user.Role, user.PartnerID, user.UpdatedAt, user.ID)
	if err != nil {
		return err
	}
	if tag.RowsAffected() == 0 {
		return errors.New("user not found")
	}
	return nil
}

func (r *userRepo) Delete(ctx context.Context, id string) error {
	runner := GetRunner(ctx, r.pool)
	query := `DELETE FROM users WHERE id = $1`
	tag, err := runner.Exec(ctx, query, id)
	if err != nil {
		return err
	}
	if tag.RowsAffected() == 0 {
		return errors.New("user not found")
	}
	return nil
}
