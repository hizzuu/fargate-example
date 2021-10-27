package router

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/hizzuu/app/internal/infrastructure"
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
	v1 := r.e.Group("/v1")
	v1.GET("/healthcheck", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{"status": "OK"})
	})
	r.setupUserRouter()
}
