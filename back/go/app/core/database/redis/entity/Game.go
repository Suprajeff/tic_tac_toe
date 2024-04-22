package entity

type Game struct {
	ID  string
	Moves        map[CellType][]CellPosition
	CurrentPlayer PlayerType
	GameState    GameState
	Winner       *PlayerType
}