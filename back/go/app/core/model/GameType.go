package model

type GameType struct {
	ID  string
	CurrentPlayer PlayerType
	GameState    GameState
	State        StateType
	Winner       *PlayerType
}