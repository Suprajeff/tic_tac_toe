package model

import "go-ttt/app/core/model"

type Move struct {
	player model.PlayerType
	position model.CellPosition
}

type Moves struct {
	player model.PlayerType
	positions []model.CellPosition
}