package model

type BoardType interface {
	boardMember()
}
type ArrayBoard struct {
Cells [][]*CellType
}

func (*ArrayBoard) boardMember() {}

type DictionaryBoard struct {
Cells map[CellPosition]CellType
}

func (*DictionaryBoard) boardMember() {}
