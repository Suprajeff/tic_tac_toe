package repository

import "go-ttt/app/core/model"

type GameUseCases interface {
	initializeGame() (*model.GameType, error)
	getGame() (*model.GameType, error)
	makeMove(row, col uint8, player *model.PlayerType) (*model.GameType, error)
	getNextPlayer() (*model.PlayerType, error)
	checkForWinner() (*model.PlayerType, error)
	checkForDraw() (bool, error)
} 