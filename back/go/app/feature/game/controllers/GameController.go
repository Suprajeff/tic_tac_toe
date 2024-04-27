package game

import repository "go-ttt/app/core/domain"

type GameController struct {
	useCases repository.GameUseCases
}

func NewGameController(gameUseCases repository.GameUseCases) *GameController {
	return &GameController{
		useCases: gameUseCases,
	}
}

