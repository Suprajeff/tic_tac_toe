package server

import (
	"fmt"
	"github.com/gorilla/mux"
	"log"
	"net/http"
	"os"
	"os/signal"
)

func CreateGorillaServer(r *mux.Router){
	
	addr := ":8080"
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
	os.Exit(0)
	
}