package redis

import (
	"go-ttt/app/core/database/redis"
	"go-ttt/app/core/model"
)

type GameRepositoryImpl struct {
	client *redis.Data
}

func NewGameRepositoryImpl(client *redis.Data) *GameRepositoryImpl {
	return &GameRepositoryImpl{client: client}
}

func (repo *GameRepositoryImpl) CreateNewGame() (*model.GameType, error) {
	
}

func (repo *GameRepositoryImpl) ResetGame() (*model.GameType, error) {
	
}

func (repo *GameRepositoryImpl) UpdateBoard(row, col uint8, player *model.PlayerType) (*model.GameType, error) {
	
}

func (repo *GameRepositoryImpl) SwitchCurrentPlayer() (*model.GameType, error) {
	
}

func (repo *GameRepositoryImpl) GetCurrentPlayer() (*model.PlayerType, error) {
	
}

func (repo *GameRepositoryImpl) GetBoardState() (*model.BoardType, error) {
	
}