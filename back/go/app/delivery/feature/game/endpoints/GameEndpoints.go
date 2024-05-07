package endpoints

import (
	"github.com/gorilla/mux"
	game "go-ttt/app/delivery/feature/game/controllers"
)

func GameEndpoints(r *mux.Router, controller *game.GameController) {
	r.HandleFunc("/hello", controller.HelloGo).Methods("GET")
	r.HandleFunc("/start", controller.StartGame).Methods("GET")
	r.HandleFunc("/restart", controller.RestartGame).Methods("GET")
	r.HandleFunc("/move", controller.MakeMove).Methods("POST")
}