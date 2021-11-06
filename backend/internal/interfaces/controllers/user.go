package controllers

import (
	"encoding/json"
	"io/ioutil"
	"net/http"
	"strconv"

	"github.com/go-chi/chi/v5"
	"github.com/hizzuu/app/internal/domain"
	"github.com/hizzuu/app/internal/interfaces/controllers/response"
	"github.com/hizzuu/app/internal/usecase/interactor"
	"github.com/hizzuu/app/utils/codes"
	"github.com/hizzuu/app/utils/errors"
)

type userController struct {
	userInteractor interactor.UserInteractor
}

func NewUserController(
	userInteractor interactor.UserInteractor,
) *userController {
	return &userController{
		userInteractor,
	}
}

func (c *userController) Get(w http.ResponseWriter, req *http.Request) {
	id, err := strconv.ParseInt(chi.URLParam(req, "id"), 10, 64)
	if err != nil {
		response.ErrJson(w, errors.Errorf(codes.BadParams, err.Error()))
		return
	}
	u, err := c.userInteractor.Get(req.Context(), id)
	if err != nil {
		response.ErrJson(w, err)
		return
	}
	response.Json(w, codes.OK, u)
}

func (c *userController) List(w http.ResponseWriter, req *http.Request) {
}

func (c *userController) Create(w http.ResponseWriter, req *http.Request) {
	body, err := ioutil.ReadAll(req.Body)
	if err != nil {
		response.ErrJson(w, errors.Errorf(codes.BadParams, err.Error()))
		return
	}
	u := &domain.User{}
	if err := json.Unmarshal(body, u); err != nil {
		response.ErrJson(w, errors.Errorf(codes.Unprocessable, err.Error()))
		return
	}
	u, err = c.userInteractor.Create(req.Context(), u)
	if err != nil {
		response.ErrJson(w, err)
		return
	}
	response.Json(w, codes.Created, u)
}

func (c *userController) Update(w http.ResponseWriter, req *http.Request) {
}

func (c *userController) Delete(w http.ResponseWriter, req *http.Request) {
}
