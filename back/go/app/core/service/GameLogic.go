package service

import (
	"go-ttt/app/core/model"
	"math/rand"
	"github.com/google/uuid"
)

type GameLogicB interface {
	generateNewID() (string, error)
	generateNewBoard() (*model.BoardType, error)
	randomPlayer() (*model.PlayerType, error)
	getNextPlayer(currentPlayer *model.PlayerType) (*model.PlayerType, error)
	checkForWinner(state *model.StateType) (*model.PlayerType, error)

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

func (gl *GameLogic) checkForWinner(state *model.StateType) (*model.PlayerType, error) {

}