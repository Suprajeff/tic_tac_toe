package redis

import (
	"context"
	"go-ttt/app/core/database/redis/dao"
	"go-ttt/app/core/database/redis/entity"
	"go-ttt/app/core/model"
	"go-ttt/app/core/data/repository"
)

type GameRepositoryImpl struct {
	data dao.GameDao
}

func NewGameRepositoryImpl(Data dao.GameDao) repository.GameRepository {
	return &GameRepositoryImpl{data: Data}
}

func (r *GameRepositoryImpl) CreateNewGame(ctx context.Context, newKey string, board model.StateType, player model.PlayerType) (*model.GameType, error) {
	return r.data.SetGame(ctx, newKey, board, player)
}

func (r *GameRepositoryImpl) ResetGame(ctx context.Context, gameID string, board model.StateType, player model.PlayerType) (*model.GameType, error) {
	return r.data.ResetGame(ctx, gameID, board, player)
}

func (r *GameRepositoryImpl) UpdateBoard(ctx context.Context, gameID string, position model.CellPosition, player model.PlayerType) (*model.StateType, error) {
	playerMove := entity.Move{Player: player, Position: position}
	return r.data.AddPlayerMove(ctx, gameID, playerMove)
}

func (r *GameRepositoryImpl) GetCurrentPlayer(ctx context.Context, gameID string) (*model.PlayerType, error) {
	gameInfo, err := r.data.GetInfo(ctx, gameID)
	if err != nil {
		return nil, err
	}
	return &gameInfo.CurrentPlayer, nil
}

func (r *GameRepositoryImpl) GetBoardState(ctx context.Context, gameID string) (*model.StateType, error) {
	gameInfo, err := r.data.GetInfo(ctx, gameID)
		if err != nil {
			return nil, err
		}
		return &gameInfo.State, nil
}

func (r *GameRepositoryImpl) GetGameState(ctx context.Context, gameID string) (*model.GameType, error) {
	return r.data.GetInfo(ctx, gameID)
}

func (r *GameRepositoryImpl) UpdateGameState(ctx context.Context, gameID string, board model.StateType, info entity.GameInfo) (*model.GameType, error) {
	return r.data.UpdateInfo(ctx, gameID, board, info)
}