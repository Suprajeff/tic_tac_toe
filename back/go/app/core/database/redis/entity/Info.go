package model

import "go-ttt/app/core/model"

type Info struct {
	gameState     model.GameState
	currentPlayer model.PlayerType
	winner *model.PlayerType
}