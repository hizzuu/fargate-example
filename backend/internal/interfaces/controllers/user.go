package controllers

import (
	"net/http"
	"strconv"

	"github.com/hizzuu/app/internal/usecase/interactor"
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

func (c *userController) Get(ctx Context) {
	id, err := strconv.ParseInt(ctx.Param("id"), 10, 64)
	if err != nil {
		ctx.JSON(http.StatusBadRequest, err)
		return
	}
	u, err := c.userInteractor.Get(ctx, id)
	if err != nil {
		ctx.JSON(http.StatusBadRequest, err)
		return
	}
	ctx.Bind(u)
	ctx.JSON(http.StatusOK, u)
}

func (c *userController) List(ctx Context) {
}

func (c *userController) Create(ctx Context) {
}

func (c *userController) Update(ctx Context) {
}

func (c *userController) Delete(ctx Context) {
}
