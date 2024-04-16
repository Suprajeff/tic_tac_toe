package model
type GameState string

const (
    InProgress GameState = "IN_PROGRESS"
    Won        GameState = "WON"
    Draw       GameState = "DRAW"
)