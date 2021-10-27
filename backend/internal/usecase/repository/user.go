package repository

import (
	"context"

	"github.com/hizzuu/app/internal/domain"
)

type UserRepository interface {
	Get(ctx context.Context, id int64) (*domain.User, error)
	List()
	Create()
	Update()
	Delete()
}
