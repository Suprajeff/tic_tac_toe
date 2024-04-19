package dao

import (
	redisInstance "go-ttt/app/core/database/redis"
)

type GameDao struct {
	*redisInstance.Data
}