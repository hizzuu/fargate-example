package router

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func (r *router) setHealthCheckRoutes() {
	v1 := r.e.Group("/v1")
	v1.GET("/healthcheck", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{"status": "OK"})
	})
}
