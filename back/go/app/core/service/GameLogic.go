package service

import "go-ttt/app/core/model"

type GameLogic interface {
	getNextPlayer() (*model.PlayerType, error)
	checkForWinner() (*model.PlayerType, error)
	checkForDraw() (bool, error)
}