package response

import (
	"encoding/json"
	"net/http"

	"github.com/hizzuu/app/utils/codes"
	"github.com/hizzuu/app/utils/errors"
)

func Json(w http.ResponseWriter, code codes.Code, data interface{}) {
	v, err := json.Marshal(data)
	if err != nil {
		ErrJson(w, errors.Errorf(code, err.Error()))
		return
	}
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(StatuCode(code))
	w.Write(v)
}

func ErrJson(w http.ResponseWriter, err error) {
	w.Header().Set("Content-Type", "application/json")
	if e, ok := err.(*errors.Error); ok {
		v, _ := json.Marshal(map[string]string{"message": err.Error()})
		w.WriteHeader(StatuCode(e.Code()))
		w.Write(v)
	} else {
		v, _ := json.Marshal(map[string]string{"message": err.Error()})
		w.WriteHeader(StatuCode(codes.Unknown))
		w.Write(v)
	}
}

func StatuCode(c codes.Code) (code int) {
	switch c {
	case codes.OK:
		code = http.StatusOK
	case codes.Created:
		code = http.StatusCreated
	case codes.BadParams, codes.EmptyBody, codes.InvalidRequest:
		code = http.StatusBadRequest
	case codes.Unauthorized:
		code = http.StatusUnauthorized
	case codes.Forbidden:
		code = http.StatusForbidden
	case codes.NotFound:
		code = http.StatusNotFound
	case codes.Unprocessable:
		code = http.StatusUnprocessableEntity
	case codes.Internal, codes.Unknown:
		code = http.StatusInternalServerError
	default:
		code = http.StatusInternalServerError
	}
	return code
}
