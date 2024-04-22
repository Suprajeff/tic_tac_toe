package entity

import "go-ttt/app/core/model"

type Game struct {
	ID  string
	Moves        map[model.CellType][]model.CellPosition
	CurrentPlayer model.PlayerType
	GameState    model.GameState
	Winner       *model.PlayerType
}