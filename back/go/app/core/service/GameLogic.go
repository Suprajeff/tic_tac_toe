package service

import "go-ttt/app/core/model"

type GameLogic interface {
	generateNewID() (*string, error)
	generateNewBoard() (*model.BoardType, error)
	randomPlayer() (*model.PlayerType, error)
	getNextPlayer() (*model.PlayerType, error)
	checkForWinner() (*model.PlayerType, error)
	checkForDraw() (bool, error)
}