package router

import (
	"github.com/gin-gonic/gin"
	"github.com/hizzuu/app/infrastructure"
)

type router struct {
	e *gin.Engine
}

func NewRouter() *router {
	if !infrastructure.AppConf.Debug {
		gin.SetMode(gin.ReleaseMode)
	}
	router := &router{gin.New()}
	router.initMiddleware()
	router.initRouting()
	return router
}

func (r *router) Run() {
	r.e.Run(":" + infrastructure.ApiConf.Addr)
}

func (r *router) initMiddleware() {
	r.e.Use(gin.Logger())
	r.e.Use(gin.Recovery())
}

func (r *router) initRouting() {
	r.setupUserRouter()
}
