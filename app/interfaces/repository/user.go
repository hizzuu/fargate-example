package repository

import "github.com/hizzuu/app/domain"

type userRepository struct {
}

func NewUserRepository() *userRepository {
	return &userRepository{}
}

func (r *userRepository) Get(id int64) (*domain.User, error) {
	u := &domain.User{}
	return u, nil
}

func (r *userRepository) List() {

}

func (r *userRepository) Create() {

}

func (r *userRepository) Update() {

}

func (r *userRepository) Delete() {

}
