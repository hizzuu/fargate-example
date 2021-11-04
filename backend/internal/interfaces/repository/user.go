package repository

import (
	"context"
	"fmt"
	"log"

	"github.com/hizzuu/app/internal/domain"
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
		err = rows.Scan(
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
		return nil, fmt.Errorf("user not found")
	}

	return list[0], nil
}

func (r *userRepository) List() {

}

func (r *userRepository) Create() {

}

func (r *userRepository) Update() {

}

func (r *userRepository) Delete() {

}
