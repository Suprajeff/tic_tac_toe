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
	return repo.client.GameDao.SetGame(ctx, newKey, board, player)
}

func (repo *GameRepositoryImpl) ResetGame(ctx context.Context, gameID string, board *model.BoardType, player *model.PlayerType) (*model.GameType, error) {
	return repo.client.GameDao.ResetGame(ctx, gameID, board, player)
}

func (repo *GameRepositoryImpl) UpdateBoard(ctx context.Context, gameID string, position *model.CellPosition, player *model.PlayerType) (*model.StateType, error) {
	playerMove := model.PlayerMove{Player: player, Position: position}
	return repo.client.GameDao.AddPlayerMove(ctx, gameID, playerMove)
}

func (repo *GameRepositoryImpl) GetCurrentPlayer(ctx context.Context, gameID string) (*model.PlayerType, error) {
	gameInfo, err := repo.client.GameDao.GetInfo(ctx, gameID)
	if err != nil {
		return nil, err
	}
	return gameInfo.CurrentPlayer.Symbol, nil
}

func (repo *GameRepositoryImpl) GetBoardState(ctx context.Context, gameID string) (*model.StateType, error) {
	gameInfo, err := repo.client.GameDao.GetInfo(ctx, gameID)
		if err != nil {
			return nil, err
		}
		return gameInfo.State, nil
}

func (repo *GameRepositoryImpl) GetGameState(ctx context.Context, gameID string) (*model.GameType, error) {
	return repo.client.GameDao.GetInfo(ctx, gameID)
}