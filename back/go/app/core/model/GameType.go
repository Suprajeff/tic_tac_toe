package model

type GameType struct {
	id  string
	Board        BoardType
	CurrentPlayer PlayerType
	GameState    GameState
	Winner       *PlayerType
}