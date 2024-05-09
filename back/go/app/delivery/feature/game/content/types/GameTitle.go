package types

type GameTitle string

const (
	PlayerXWon GameTitle = "Player X Won"
	PlayerOWon GameTitle = "Player O Won"
	Playing GameTitle = "Playing"
	Draw GameTitle = "Draw"
)