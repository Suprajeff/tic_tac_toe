package database

import (
	"context"
	"fmt"
	"github.com/redis/go-redis/v9"
	"log"
	"os"
)

type Client struct {
	*redis.Client
}

func NewRedisClient() *Client {

	redisHost := os.Getenv("REDIS_HOST")
	if redisHost == "" {
		redisHost = "redis" // Default to "localhost"
	}
//	addr := fmt.Sprintf("%s:6379", redisHost)

	client := redis.NewClient(&redis.Options{
		Addr:     "redis:6379",
		Password: "",
		DB:       0,
	})

	return &Client{client}
}

func (c *Client) Connect() {
	ctx := context.Background()
	pong, err := c.Ping(ctx).Result()
	if err != nil {
		log.Fatalf("Error connecting to Redis: %v", err)
	}
	fmt.Println(pong)
}