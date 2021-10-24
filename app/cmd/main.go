package main

import (
	"github.com/hizzuu/app/infrastructure"
)

func main() {
	router := infrastructure.NewRouter()
	router.Run()
}
