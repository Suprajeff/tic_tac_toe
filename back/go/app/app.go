package main

import (
	"fmt"
	"github.com/gorilla/mux"
	"go-ttt/app/connections/config"
	"go-ttt/app/connections/infrastructure/database"
	"go-ttt/app/delivery/feature/game"
	"go-ttt/app/delivery/middlewares"
	"log"
	"net/http"
	"os"
	"os/signal"
)

func main() {

	env := config.GetEnvironment()
	fmt.Println("Session Secret: ", env.SessionSecret)

	// Db Setup
	client := database.NewRedisClient()
	client.Connect()

	// Router
	r := mux.NewRouter()

	game.LaunchGameFeature(client, r)

	r.Use(middlewares.CorsMiddleware())

	addr := ":8085"
	log.Printf("Starting server on %s", addr)
	fmt.Println("Address: ", addr)

	// Start Server
	err := http.ListenAndServe(addr, r)
	if err != nil {
		return
	}

	// Graceful Shutdown
	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt)
	<-c
	fmt.Println("Gracefully shutting down...")
	err = client.Close()
	if err != nil {
		return
	}
	os.Exit(0)


}