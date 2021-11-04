package domain

import "time"

type User struct {
	ID                int64
	Name              string
	Email             string
	EncryptedPassword string
	CreatedAt         time.Time
	UpdatedAt         time.Time
}
