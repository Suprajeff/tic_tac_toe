package repository

import (
	"context"
	"go-ttt/app/core/database/redis/entity"
	"go-ttt/app/core/model"
)

type GameRepository interface {
	CreateNewGame(ctx context.Context, newKey string, board *model.StateType, player *model.PlayerType) (*model.GameType, error)
	ResetGame(ctx context.Context, gameID string, board *model.StateType, player *model.PlayerType) (*model.GameType, error)
	UpdateBoard(ctx context.Context, gameID string, position *model.CellPosition, player *model.PlayerType) (*model.StateType, error)
	GetCurrentPlayer(ctx context.Context, gameID string) (*model.PlayerType, error)
	GetBoardState(ctx context.Context, gameID string) (*model.StateType, error)
	GetGameState(ctx context.Context, gameID string) (*model.GameType, error)
	UpdateGameState(ctx context.Context, gameID string, board *model.StateType, info *entity.GameInfo) (*model.GameType, error)
}