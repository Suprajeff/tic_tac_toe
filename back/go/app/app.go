package main

import (
	"fmt"
	"github.com/gorilla/mux"
	"go-ttt/app/connections/config"
	"go-ttt/app/connections/infrastructure/database"
	"go-ttt/app/connections/infrastructure/server"
	"go-ttt/app/delivery/feature/game"
	"go-ttt/app/delivery/middlewares"
)

func main() {

	env := config.GetEnvironment()
	fmt.Println("Session Secret: ", env.SessionSecret)

	// Db Setup
	client := database.NewRedisClient()
	client.Connect()

	// Router
	r := mux.NewRouter()

	r.Use(middlewares.GetSettingsPreferences)

	game.LaunchGameFeature(client, r)

	r.Use(middlewares.CorsMiddleware())

	server.CreateGorillaServer(r)

}