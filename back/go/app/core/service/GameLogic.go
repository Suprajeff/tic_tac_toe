package service

import "go-ttt/app/core/model"

type GameLogicB interface {
	generateNewID() (*string, error)
	generateNewBoard() (*model.BoardType, error)
	randomPlayer() (*model.PlayerType, error)
	getNextPlayer(currentPlayer *model.PlayerType) (*model.PlayerType, error)
	checkForWinner(state *model.StateType) (*model.PlayerType, error)
	checkForDraw(state *model.StateType) (bool, error)
}

type GameLogic struct{}

func NewGameLogic() GameLogicB {
	return &GameLogic{}
}

func (gl *GameLogic) generateNewID() (*string, error) {
	
}

func (gl *GameLogic) generateNewBoard() (*model.BoardType, error) {

}
func (gl *GameLogic) randomPlayer() (*model.PlayerType, error) {

}
func (gl *GameLogic) getNextPlayer(currentPlayer *model.PlayerType) (*model.PlayerType, error) {

}
func (gl *GameLogic) checkForWinner(state *model.StateType) (*model.PlayerType, error) {

}
func (gl *GameLogic) checkForDraw(state *model.StateType) (bool, error) {

}