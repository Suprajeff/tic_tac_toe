package service

import "go-ttt/app/core/model"

type GameStateCheckerB interface {
	checkForVictoryOrDrawA(cells [][]*model.CellType) (*model.GameResult, error)
	checkForVictoryOrDrawB(cells map[model.CellPosition]*model.CellType) (*model.GameResult, error)
	checkForVictoryOrDrawC(playersHands map[model.CellType][]model.CellPosition) (*model.GameResult, error)
}

type GameStateChecker struct{}

func NewGameStateChecker() GameStateCheckerB {
	return &GameStateChecker{}
}

func (gsc *GameStateChecker) checkForVictoryOrDrawA(cells [][]*model.CellType) (*model.GameResult, error) {

}

func (gsc *GameStateChecker) checkForVictoryOrDrawB(cells map[model.CellPosition]*model.CellType) (*model.GameResult, error) {

}

func (gsc *GameStateChecker) checkForVictoryOrDrawC(playersHands map[model.CellType][]model.CellPosition) (*model.GameResult, error) {

}