package dao

import (
	redisInstance "go-ttt/app/core/database/redis"
	"go-ttt/app/core/database/redis/entity"
)

type GameDao struct {
	*redisInstance.Data
}

type GameDaoProtocol interface {
	addPlayerMove(move *entity.Move) (*entity.Moves, error)
	getPlayerMoves(move *entity.Move) (*entity.Moves, error)
	getInfo(gameID string) (*entity.GameInfo, error)
	updateInfo(gameID string, info *entity.GameInfo) (*entity.GameInfo, error)
}

func (dao *GameDao) addPlayerMove(move entity.Move) (entity.Moves, error) {
	err := dao.Redis.SAdd(move.Player, move.Position).Err()
	if err != nil {
		return entity.Moves{}, err
	}

	positions, err := dao.Redis.SMembers(move.Player).Result()
	if err != nil {
		return entity.Moves{}, err
	}

	return entity.Moves{
		Player:    move.Player,
		Positions: positions,
	}, nil
}

func (dao *GameDao) getPlayerMoves(move entity.Move) (entity.Moves, error) {
	positions, err := dao.Redis.SMembers(move.Player).Result()
	if err != nil {
		return entity.Moves{}, err
	}

	return entity.Moves{
		Player:    move.Player,
		Positions: positions,
	}, nil
}

func (dao *GameDao) getInfo(gameID string) (*entity.GameInfo, error) {
	info, err := dao.Redis.HMGet(gameID, "currentPlayer", "gameState", "winner").Result()
	if err != nil {
		return nil, err
	}

	return &entity.GameInfo{
		CurrentPlayer: info[0].(string),
		GameState:     info[1].(string),
		Winner:        info[2].(string),
	}, nil
}

func (dao *GameDao) updateInfo(gameID string, info *entity.GameInfo) (*entity.GameInfo, error) {
	err := dao.Redis.HMSet(gameID, map[string]interface{}{
		"currentPlayer": info.CurrentPlayer,
		"gameState":     info.GameState,
		"winner":        info.Winner,
	}).Err()
	if err != nil {
		return nil, err
	}

	return info, nil
}

