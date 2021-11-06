package router

import (
	"github.com/go-chi/chi/v5"
	"github.com/hizzuu/app/internal/interfaces/controllers"
	"github.com/hizzuu/app/internal/interfaces/repository"
	"github.com/hizzuu/app/internal/usecase/interactor"
)

func (r *router) setUserRoutes() {
	userCtrl := controllers.NewUserController(
		interactor.NewUserInteractor(
			repository.NewUserRepository(r.sqlHandler),
		),
	)
	r.e.Route("/v1/users", func(r chi.Router) {
		r.Get("/{id}", userCtrl.Get)
		r.Get("/", userCtrl.List)
		r.Post("/", userCtrl.Create)
		r.Put("/{id}", userCtrl.Update)
		r.Delete("/{id}", userCtrl.Delete)
	})
}
