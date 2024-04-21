package entity

import "go-ttt/app/core/model"

type Move struct {
	Player   model.PlayerType
	position model.CellPosition
}

type Moves struct {
	player model.PlayerType
	positions []model.CellPosition
}