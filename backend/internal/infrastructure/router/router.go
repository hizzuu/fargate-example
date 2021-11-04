package router

import (
	"github.com/gin-gonic/gin"
	"github.com/hizzuu/app/internal/infrastructure"
)

type router struct {
	e          *gin.Engine
	sqlHandler infrastructure.SqlHandler
}

func NewRouter(sqlHandler infrastructure.SqlHandler) *router {
	if !infrastructure.AppConf.Debug {
		gin.SetMode(gin.ReleaseMode)
	}
	r := &router{gin.New(), sqlHandler}

	// use middleware
	r.e.Use(gin.Logger())
	r.e.Use(gin.Recovery())

	// set routes
	r.setHealthCheckRoutes()
	r.setUserRoutes()
	return r
}

func (r *router) Run() {
	r.e.Run(":" + infrastructure.ApiConf.Addr)
}
