package controllers

import (
	repository "go-ttt/app/core/domain"
	"net/http"
)

type GameController struct {
	useCases repository.GameUseCases
}

func NewGameController(gameUseCases repository.GameUseCases) *GameController {
	return &GameController{
		useCases: gameUseCases,
	}
}

func (gc *GameController) StartGame(w http.ResponseWriter, r *http.Request) {

}

func (gc *GameController) RestartGame(w http.ResponseWriter, r *http.Request) {

}

func (gc *GameController) MakeMove(w http.ResponseWriter, r *http.Request) {

}

