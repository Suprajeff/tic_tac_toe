package model

type CellPosition uint8

const (
	TL CellPosition = iota
	T
	TR
	L
	C
	R
	BL
	B
	BR
)