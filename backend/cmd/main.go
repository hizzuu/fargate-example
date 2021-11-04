package main

import (
	"log"

	"github.com/hizzuu/app/internal/infrastructure"
	"github.com/hizzuu/app/internal/infrastructure/router"
)

func main() {
	db, err := infrastructure.NewMySQLDB()
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()
	router := router.NewRouter(infrastructure.NewSqlHandler(db))
	router.Run()
}
