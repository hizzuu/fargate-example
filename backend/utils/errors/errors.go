package errors

import (
	"fmt"

	"github.com/hizzuu/app/utils/codes"
	"github.com/pkg/errors"
)

type Error struct {
	Err  error
	code codes.Code
}

type ErrorCode uint64

func (e *Error) Error() string {
	return e.Err.Error()
}

func (e *Error) Code() codes.Code {
	if e.Err == nil {
		return codes.OK
	}
	return e.code
}

func Errorf(c codes.Code, format string, a ...interface{}) error {
	if c == codes.OK {
		return nil
	}
	return &Error{
		code: c,
		Err:  errors.Errorf(format, a...),
	}
}

func (e *Error) StackTrace() string {
	return fmt.Sprintf("%+v\n", e.Err)
}
