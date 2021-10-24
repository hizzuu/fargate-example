package domain

type Error interface {
	Error() string
	StatusCode() int
}
