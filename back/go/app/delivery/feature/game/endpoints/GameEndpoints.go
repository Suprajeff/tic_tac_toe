package endpoints

import (
	"github.com/gorilla/mux"
	game "go-ttt/app/delivery/feature/game/controllers"
)

func GameEndpoints(r *mux.Router, controller *game.GameController) {
	r.HandleFunc("/start", controller.StartGame).Methods("POST")
	r.HandleFunc("/restart", controller.RestartGame).Methods("POST")
	r.HandleFunc("/move", controller.MakeMove).Methods("POST")
}