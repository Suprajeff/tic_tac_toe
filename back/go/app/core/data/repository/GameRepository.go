package repository

import "go-ttt/app/core/model"

type GameRepository interface {
	createNewGame() (*model.GameType, error)
	resetGame() (*model.GameType, error)
	updateBoard(row, col uint8, player *model.PlayerType) (*model.GameType, error)
	switchCurrentPlayer() (*model.GameType, error)
	getCurrentPlayer() (*model.PlayerType, error)
	getBoardState() (*model.BoardType, error)
	getGameState() (*model.GameType, error)
}