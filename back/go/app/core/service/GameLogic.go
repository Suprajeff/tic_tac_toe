package service

import (
	"errors"
	"fmt"
	"go-ttt/app/core/model"
	"math/rand"
	"github.com/google/uuid"
)

type GameLogicB interface {
	generateNewID() (string, error)
	generateNewBoard() (*model.BoardType, error)
	randomPlayer() (*model.PlayerType, error)
	getNextPlayer(currentPlayer *model.PlayerType) (*model.PlayerType, error)
	checkForWinner(state model.StateType) (bool, *model.PlayerType, error)
}

type GameLogic struct{}

func NewGameLogic() GameLogicB {
	return &GameLogic{}
}

func (gl *GameLogic) generateNewID() (string, error) {
	newID, err := uuid.NewRandom()
	if err != nil {
		return "", err
	}
	return newID.String(), nil
}

func (gl *GameLogic) generateNewBoard() (*model.BoardType, error) {
	board := &model.ArrayBoard{
			Cells: [][]*model.CellType{
				{nil, nil, nil},
				{nil, nil, nil},
				{nil, nil, nil},
			},
		}

	var boardAsBoardType model.BoardType = board

	return &boardAsBoardType, nil
}

func (gl *GameLogic) randomPlayer() (*model.PlayerType, error) {
	symbols := []string{"X", "O"}
		rand.Shuffle(len(symbols), func(i, j int) {
			symbols[i], symbols[j] = symbols[j], symbols[i]
		})
		symbol := symbols[0]
		player := model.PlayerType{Symbol: model.CellType(symbol)}
		return &player, nil
}

func (gl *GameLogic) getNextPlayer(currentPlayer *model.PlayerType) (*model.PlayerType, error) {
	var nextSymbol string
	if currentPlayer.Symbol == "X" {
		nextSymbol = "O"
	} else {
		nextSymbol = "X"
	}
	nextPlayer := model.PlayerType{Symbol: model.CellType(nextSymbol)}
	return &nextPlayer, nil
}

func (gl *GameLogic) checkForWinner(state model.StateType) (bool, *model.PlayerType, error) {

	winningCombinations := [][]model.CellPosition{
		{model.TL, model.T, model.TR}, // Rows
		{model.L, model.C, model.R},
		{model.BL, model.B, model.BR},
		{model.TL, model.L, model.BL}, // Columns
		{model.T, model.C, model.B},
		{model.TR, model.R, model.BR},
		{model.TL, model.C, model.BR}, // Diagonals
		{model.TR, model.C, model.BL},
	}

	var cells map[model.CellPosition]model.CellType

	switch state := state.(type) {
		case *model.BoardState:
			switch board := state.BoardType.(type) {
			case *model.ArrayBoard:
				cells = make(map[model.CellPosition]model.CellType)
				for i, row := range board.Cells {
					for j, cell := range row {
						pos := model.CellPosition(fmt.Sprintf("%d%d", i, j))
						cells[pos] = *cell
					}
				}
			case *model.DictionaryBoard:
				cells = board.Cells
			}
		case *model.MovesState:
				cells = make(map[model.CellPosition]model.CellType)
				for player, moves := range state.PlayersMoves {
					for _, pos := range moves {
						cells[pos] = player
					}
				}
		default:
			return false, nil, errors.New("invalid state type")
	}

	for _, combination := range winningCombinations {
		pos1, pos2, pos3 := combination[0], combination[1], combination[2]
		cell1, ok1 := cells[pos1]
		cell2, ok2 := cells[pos2]
		cell3, ok3 := cells[pos3]
		if ok1 && ok2 && ok3 && cell1 == cell2 && cell2 == cell3 {
		return true, &model.PlayerType{Symbol: cell1}, nil
		}
	}

	return false, nil, nil

}