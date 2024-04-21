package dao

import (
	"context"
	"fmt"
	redisInstance "go-ttt/app/core/database/redis"
	util "go-ttt/app/core/database/redis/util"
	"go-ttt/app/core/database/redis/entity"
	"go-ttt/app/core/model"
)

type GameDao struct {
	*redisInstance.Data
}

type GameDaoProtocol interface {
	addPlayerMove(gameID string, move *entity.Move) (*entity.Moves, error)
	getPlayerMoves(gameID string, move *entity.Move) (*entity.Moves, error)
	getInfo(gameID string) (*entity.GameInfo, error)
	updateInfo(gameID string, info *entity.GameInfo) (*entity.GameInfo, error)
}

func (dao *GameDao) addPlayerMove(ctx context.Context, gameID string, move entity.Move) (entity.Moves, error) {

	key := fmt.Sprintf("%s:moves:%s", gameID, move.Player)

	err := dao.Redis.SAdd(ctx, key, string(move.Position)).Err()
	if err != nil {
		return entity.Moves{}, err
	}

	positions, err := dao.Redis.SMembers(ctx, key).Result()
	if err != nil {
		return entity.Moves{}, err
	}

	cellPositions := make([]model.CellPosition, len(positions))
	for i, pos := range positions {
		cellPositions[i], err = util.StringToCellPosition(pos)
		if err != nil {
			return entity.Moves{}, err
		}
	}

	return entity.Moves{
		Player:    move.Player,
		Positions: cellPositions,
	}, nil
}

func (dao *GameDao) getPlayerMoves(ctx context.Context, gameID string, move entity.Move) (entity.Moves, error) {

	key := fmt.Sprintf("%s:moves:%s", gameID, move.Player)

	positions, err := dao.Redis.SMembers(ctx, key).Result()
	if err != nil {
		return entity.Moves{}, err
	}

	cellPositions := make([]model.CellPosition, len(positions))
	for i, pos := range positions {
		cellPositions[i], err = util.StringToCellPosition(pos)
		if err != nil {
			return entity.Moves{}, err
		}
	}

	return entity.Moves{
		Player:    move.Player,
		Positions: cellPositions,
	}, nil
}

func (dao *GameDao) getInfo(ctx context.Context, gameID string) (*entity.GameInfo, error) {

	key := fmt.Sprintf("%s:info", gameID)

	info, err := dao.Redis.HMGet(ctx, key, "currentPlayer", "gameState", "winner").Result()
	if err != nil {
		return nil, err
	}

	currentPlayerData, err := util.StringToPlayerType(info[0])
	if err != nil {
		return nil, err
	}

	gameStateData, err := util.StringToGameState(info[1])
	if err != nil {
		return nil, err
	}

	winnerData, err := util.StringToPlayerType(info[2])
	if err != nil {
		return nil, err
	}

	return &entity.GameInfo{
		CurrentPlayer: currentPlayerData,
		GameState:     gameStateData,
		Winner:        winnerData,
	}, nil
}

func (dao *GameDao) updateInfo(ctx context.Context, gameID string, info *entity.GameInfo) (*entity.GameInfo, error) {

	key := fmt.Sprintf("%s:info", gameID)

	err := dao.Redis.HMSet(ctx, key, map[string]interface{}{
		"currentPlayer": info.CurrentPlayer,
		"gameState":     info.GameState,
		"winner":        info.Winner,
	}).Err()
	if err != nil {
		return nil, err
	}

	return info, nil
}

