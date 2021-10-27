package repository

import "github.com/hizzuu/app/internal/domain"

type UserRepository interface {
	Get(id int64) (*domain.User, error)
	List()
	Create()
	Update()
	Delete()
}
