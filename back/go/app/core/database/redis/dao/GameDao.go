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
	updateInfo() (*entity.GameInfo, error)
}