package service

import "go-ttt/app/core/model"

type GameStateChecker interface {
	checkForVictoryOrDrawA(cells [][]*model.CellType) (*model.GameResult, error)
	checkForVictoryOrDrawB(cells map[model.CellPosition]*model.CellType) (*model.GameResult, error)
	checkForVictoryOrDrawC(playersHands map[model.CellType][]model.CellPosition) (*model.GameResult, error)
}