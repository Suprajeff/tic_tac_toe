package entity

import "go-ttt/app/core/model"

type Move struct {
	Player   model.PlayerType
	Position model.CellPosition
}

type Moves struct {
	Player model.PlayerType
	Positions []model.CellPosition
}