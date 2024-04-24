package repository

import (
	"go-ttt/app/core/data/repository"
	"go-ttt/app/core/model"
)

type GameUseCases interface {
	initializeGame() (*model.GameType, error)
	resetGame(gameID string) (*model.GameType, error)
	makeMove(gameID string, position *model.CellPosition, player *model.PlayerType) (*model.GameType, error)
}
type GameUseCasesImpl struct {
	gameRepo repository.GameRepository
}

func NewGameUseCases(repo repository.GameRepository) GameUseCases {
	return &GameUseCasesImpl{
		gameRepo: repo,
	}
}

func (uc *GameUseCasesImpl) initializeGame() (*model.GameType, error) {
	return &model.GameType{}, nil
}

func (uc *GameUseCasesImpl) resetGame(gameID string) (*model.GameType, error) {
	return &model.GameType{}, nil
}

func (uc *GameUseCasesImpl) makeMove(gameID string, position *model.CellPosition, player *model.PlayerType) (*model.GameType, error) {
	return &model.GameType{}, nil
}

