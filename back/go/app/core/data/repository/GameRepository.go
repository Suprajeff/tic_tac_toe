package repository

import (
	"context"
	"go-ttt/app/core/model"
)

type GameRepository interface {
	createNewGame(ctx context.Context, newKey string, board *model.BoardType, player *model.PlayerType) (*model.GameType, error)
	resetGame(ctx context.Context, gameID string, board *model.BoardType, player *model.PlayerType) (*model.GameType, error)
	updateBoard(ctx context.Context, gameID string, position *model.CellPosition, player *model.PlayerType) (*model.GameType, error)
	getCurrentPlayer(ctx context.Context, gameID string) (*model.PlayerType, error)
	getBoardState(ctx context.Context, gameID string) (*model.StateType, error)
	getGameState(ctx context.Context, gameID string) (*model.GameType, error)
}