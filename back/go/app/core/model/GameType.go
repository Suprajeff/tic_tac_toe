package model

type GameType struct {
	ID  string
	Board        BoardType
	CurrentPlayer PlayerType
	GameState    GameState
	Winner       *PlayerType
}