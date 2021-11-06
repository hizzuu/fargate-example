package controllers

import (
	"net/http"

	"github.com/hizzuu/app/internal/interfaces/controllers/response"
	"github.com/hizzuu/app/utils/codes"
)

func HandleHealthCheck(w http.ResponseWriter, r *http.Request) {
	response.Json(w, codes.OK, map[string]bool{"alive": true})
}
