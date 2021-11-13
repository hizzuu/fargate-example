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

type UserController struct {
	userInteractor interactor.UserInteractor
}

func NewUserController(userInteractor interactor.UserInteractor) *UserController {
	return &UserController{
		userInteractor,
	}
}

func (c *UserController) Get(w http.ResponseWriter, req *http.Request) {
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

func (c *UserController) List(w http.ResponseWriter, req *http.Request) {
}

func (c *UserController) Create(w http.ResponseWriter, req *http.Request) {
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

func (c *UserController) Update(w http.ResponseWriter, req *http.Request) {
}

func (c *UserController) Delete(w http.ResponseWriter, req *http.Request) {
}
