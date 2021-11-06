package repository

import (
	"context"
	"log"

	"github.com/hizzuu/app/internal/domain"
	"github.com/hizzuu/app/utils/codes"
	"github.com/hizzuu/app/utils/errors"
)

type userRepository struct {
	db sqlHandler
}

func NewUserRepository(db sqlHandler) *userRepository {
	return &userRepository{db}
}

func (r *userRepository) fetch(ctx context.Context, query string, args ...interface{}) ([]*domain.User, error) {
	stmt, err := r.db.PrepareContext(ctx, query)
	if err != nil {
		return nil, err
	}
	defer stmt.Close()
	rows, err := stmt.QueryContext(ctx, args...)
	if err != nil {
		return nil, err
	}
	defer func() {
		err := rows.Close()
		if err != nil {
			log.Println(err)
		}
	}()
	result := make([]*domain.User, 0)
	for rows.Next() {
		u := new(domain.User)
		err := rows.Scan(
			&u.ID,
			&u.Name,
			&u.Email,
			&u.CreatedAt,
			&u.UpdatedAt,
		)
		if err != nil {
			return nil, err
		}
		result = append(result, u)
	}

	return result, nil
}

func (r *userRepository) Get(ctx context.Context, id int64) (*domain.User, error) {
	query := `SELECT id, name, email, updated_at, created_at
            FROM users
            WHERE id = ?`

	list, err := r.fetch(ctx, query, id)
	if err != nil {
		return nil, err
	}

	if len(list) == 0 {
		return nil, errors.Errorf(codes.NotFound, "user with id='%d' is not found", id)
	}

	return list[0], nil
}

func (r *userRepository) List() {

}

func (r *userRepository) Create(ctx context.Context, u *domain.User) (*domain.User, error) {
	query := `INSERT users SET name=?, email=?, encrypted_password=?`
	stm, err := r.db.PrepareContext(ctx, query)
	if err != nil {
		return nil, err
	}
	result, err := stm.ExecContext(ctx, u.Name, u.Email, u.EncryptedPassword)
	if err != nil {
		return nil, err
	}
	id, err := result.LastInsertId()
	if err != nil {
		return nil, err
	}
	return r.Get(ctx, id)
}

func (r *userRepository) Update() {

}

func (r *userRepository) Delete() {

}
