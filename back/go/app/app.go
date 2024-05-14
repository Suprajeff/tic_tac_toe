package main

import (
	"fmt"
	"github.com/gorilla/mux"
	"go-ttt/app/connections/config"
	"go-ttt/app/connections/infrastructure/database"
	"go-ttt/app/connections/infrastructure/server"
	"go-ttt/app/delivery/feature/game"
	"go-ttt/app/delivery/middlewares/cors"
)

func main() {

	env := config.GetEnvironment()
	fmt.Println("Session Secret: ", env.SessionSecret)

	// Db Setup
	client := database.NewRedisClient()
	client.Connect()

	// Router
	r := mux.NewRouter()
	r.Use(middlewares.CorsMiddleware())

	game.LaunchGameFeature(client, r)

	middlewares.AllRoutes(r)

	server.CreateGorillaServer(r)

}