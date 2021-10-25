package main

import (
	"github.com/hizzuu/app/infrastructure/router"
)

func main() {
	router := router.NewRouter()
	router.Run()
}
