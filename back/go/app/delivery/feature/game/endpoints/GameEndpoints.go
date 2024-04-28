package endpoints

import (
	game "go-ttt/app/delivery/feature/game/controllers"
	"github.com/gorilla/mux"
)

func GameEndpoints(r *mux.Router, controller *game.GameController) {
	r.HandleFunc("/start", controller.StartGame).Methods("POST")
	r.HandleFunc("/restart", controller.RestartGame).Methods("POST")
	r.HandleFunc("/move", controller.MakeMove).Methods("POST")
}