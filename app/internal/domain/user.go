package domain

type User struct {
	ID                int64
	Name              string
	Email             string
	EncryptedPassword string
}
