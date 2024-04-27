package service

import (
	"errors"
	"github.com/google/uuid"
	"go-ttt/app/core/model"
	"math/rand"
)

type GameLogicB interface {
	GenerateNewID() (string, error)
	GenerateNewBoard() (*model.BoardType, error)
	RandomPlayer() (*model.PlayerType, error)
	GetNextPlayer(currentPlayer *model.PlayerType) (*model.PlayerType, error)
	CheckForWinner(state model.StateType) (*model.GameResult, error)
}

type GameLogic struct{
	checker GameStateCheckerB
}

func NewGameLogic(gameStateChecker GameStateCheckerB) GameLogicB {
	return &GameLogic{
		checker: gameStateChecker,
	}
}

func (gl *GameLogic) GenerateNewID() (string, error) {
	newID, err := uuid.NewRandom()
	if err != nil {
		return "", err
	}
	return newID.String(), nil
}

func (gl *GameLogic) GenerateNewBoard() (*model.BoardType, error) {
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

func (gl *GameLogic) RandomPlayer() (*model.PlayerType, error) {
	symbols := []string{"X", "O"}
		rand.Shuffle(len(symbols), func(i, j int) {
			symbols[i], symbols[j] = symbols[j], symbols[i]
		})
		symbol := symbols[0]
		player := model.PlayerType{Symbol: model.CellType(symbol)}
		return &player, nil
}

func (gl *GameLogic) GetNextPlayer(currentPlayer *model.PlayerType) (*model.PlayerType, error) {
	var nextSymbol string
	if currentPlayer.Symbol == "X" {
		nextSymbol = "O"
	} else {
		nextSymbol = "X"
	}
	nextPlayer := model.PlayerType{Symbol: model.CellType(nextSymbol)}
	return &nextPlayer, nil
}

func (gl *GameLogic) CheckForWinner(state model.StateType) (*model.GameResult, error) {

	switch state := state.(type) {
		case *model.BoardState:
			switch board := state.BoardType.(type) {
			case *model.ArrayBoard:
				result, err := gl.checker.CheckForVictoryOrDrawA(board.Cells)
				if err != nil {
					return nil, err
				}
				return result, nil
			case *model.DictionaryBoard:
				result, err := gl.checker.CheckForVictoryOrDrawB(board.Cells)
				if err != nil {
					return nil, err
				}
				return result, nil
			}
		case *model.MovesState:
			result, err := gl.checker.CheckForVictoryOrDrawC(state.PlayersMoves)
			if err != nil {
				return nil, err
			}
			return result, nil
		default:
			return nil, errors.New("invalid state type")
	}

	return nil, errors.New("invalid state type")

}