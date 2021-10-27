package main

import "github.com/hizzuu/app/internal/infrastructure/router"

func main() {
	router := router.NewRouter()
	router.Run()
}
