package main

import (
	"fmt"
	"github.com/gorilla/mux"
	"go-ttt/app/connections/config"
	"go-ttt/app/connections/infrastructure/database"
	"go-ttt/app/connections/infrastructure/server"
	"go-ttt/app/delivery/feature/game"
	cors "go-ttt/app/delivery/middlewares/cors"
	session "go-ttt/app/delivery/middlewares/session"
)

func main() {

	env := config.GetEnvironment()
	fmt.Println("Session Secret: ", env.SessionSecret)

	// Db Setup
	client := database.NewRedisClient()
	client.Connect()

	// Cookie Store
	store := session.CreateCookieStore()

	// Router
	r := mux.NewRouter()
	r.Use(cors.CorsMiddleware())
	r.Use(session.SessionMiddleware(store))

	game.LaunchGameFeature(client, r, store)

	cors.AllRoutes(r)

	server.CreateGorillaServer(r)

}