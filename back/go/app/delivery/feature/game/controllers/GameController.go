package controllers

import (
	repository "go-ttt/app/core/domain"
	"go-ttt/app/delivery/utils/responses"
	"net/http"
)

type GameController struct {
	useCases repository.GameUseCases
	sResponse responses.GameResponses
}

func NewGameController(gameUseCases repository.GameUseCases, gameResponses responses.GameResponses) *GameController {
	return &GameController{
		useCases: gameUseCases,
		sResponse: gameResponses
	}
}

func (gc *GameController) StartGame(w http.ResponseWriter, r *http.Request) {

}

func (gc *GameController) RestartGame(w http.ResponseWriter, r *http.Request) {

}

func (gc *GameController) MakeMove(w http.ResponseWriter, r *http.Request) {

}

