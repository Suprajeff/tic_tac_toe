package repository

import "go-ttt/app/core/model"

type GameUseCases interface {
	initializeGame() (*model.GameType, error)
	resetGame() (*model.GameType, error)
	makeMove(row, col uint8, player *model.PlayerType) (*model.GameType, error)
} 