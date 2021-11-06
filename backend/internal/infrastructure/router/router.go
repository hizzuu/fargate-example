package router

import (
	"net/http"

	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
	"github.com/hizzuu/app/internal/infrastructure"
)

type router struct {
	e          *chi.Mux
	sqlHandler infrastructure.SqlHandler
}

func NewRouter(sqlHandler infrastructure.SqlHandler) *router {
	r := &router{chi.NewRouter(), sqlHandler}
	// use middleware
	r.e.Use(middleware.Logger)
	// set routes
	r.setHealthCheckRoutes()
	r.setUserRoutes()
	return r
}

func (r *router) Run() {
	http.ListenAndServe(":"+infrastructure.ApiConf.Addr, r.e)
}
