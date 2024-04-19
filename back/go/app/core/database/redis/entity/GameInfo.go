package model

import "go-ttt/app/core/model"

type GameInfo struct {
	gameState     model.GameState
	currentPlayer model.PlayerType
	winner *model.PlayerType
}