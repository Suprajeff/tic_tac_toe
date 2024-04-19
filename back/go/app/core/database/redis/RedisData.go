package  redis

import "github.com/redis/go-redis/v9"

type Data struct {
	Redis *redis.Client
}

func NewRedis(client *redis.Client) *Data {
	return &Data{Redis: client}
}