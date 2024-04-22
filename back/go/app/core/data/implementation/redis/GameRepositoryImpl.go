package redis

import (
	"context"
	"go-ttt/app/core/database/redis"
	"go-ttt/app/core/model"
)

type GameRepositoryImpl struct {
	client *redis.Data
}

func NewGameRepositoryImpl(client *redis.Data) *GameRepositoryImpl {
	return &GameRepositoryImpl{client: client}
}

func (repo *GameRepositoryImpl) CreateNewGame(ctx context.Context, newKey string, board *model.BoardType, player *model.PlayerType) (*model.GameType, error) {
	
}

func (repo *GameRepositoryImpl) ResetGame(ctx context.Context, gameID string, board *model.BoardType, player *model.PlayerType) (*model.GameType, error) {
	
}

func (repo *GameRepositoryImpl) UpdateBoard(ctx context.Context, gameID string, position *model.CellPosition, player *model.PlayerType) (*model.GameType, error) {
	
}

func (repo *GameRepositoryImpl) SwitchCurrentPlayer(ctx context.Context, gameID string) (*model.GameType, error) {
	
}

func (repo *GameRepositoryImpl) GetCurrentPlayer(ctx context.Context, gameID string) (*model.PlayerType, error) {
	
}

func (repo *GameRepositoryImpl) GetBoardState(ctx context.Context, gameID string) (*model.BoardType, error) {
	
}

func (repo *GameRepositoryImpl) GetGameState(ctx context.Context, gameID string) (*model.GameType, error) {

}