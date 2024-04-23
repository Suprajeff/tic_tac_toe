package model

type StateType interface {
	stateMember()
}

type BoardState struct {
	BoardType
}

func (*BoardState) stateMember() {}

type MovesState struct {
	PlayerMoves
}

func (*MovesState) stateMember() {}