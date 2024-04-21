package entity

import "go-ttt/app/core/model"

type GameInfo struct {
	GameState     model.GameState
	CurrentPlayer model.PlayerType
	Winner *model.PlayerType
}