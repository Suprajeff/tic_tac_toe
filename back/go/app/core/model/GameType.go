package model

type GameType struct {
	Board        BoardType
	CurrentPlayer PlayerType
	GameState    GameState
	Winner       *PlayerType
}