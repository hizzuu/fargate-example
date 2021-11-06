package router

import (
	"github.com/go-chi/chi/v5"
	"github.com/hizzuu/app/internal/interfaces/controllers"
)

func (r *router) setHealthCheckRoutes() {
	r.e.Route("/v1/healthcheck", func(r chi.Router) {
		r.Get("/", controllers.HandleHealthCheck)
	})
}
