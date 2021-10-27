package controllers

import (
	"time"
)

type Context interface {
	Deadline() (deadline time.Time, ok bool)
	Done() <-chan struct{}
	Err() error
	Value(key interface{}) interface{}
	Param(string) string
	Bind(interface{}) error
	Status(int)
	JSON(int, interface{})
}
