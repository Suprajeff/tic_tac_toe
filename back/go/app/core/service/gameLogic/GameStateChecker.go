package service

import "go-ttt/app/core/model"

type GameStateCheckerB interface {
	CheckForVictoryOrDrawA(cells [][]*model.CellType) (*model.GameResult, error)
	CheckForVictoryOrDrawB(cells map[model.CellPosition]*model.CellType) (*model.GameResult, error)
	CheckForVictoryOrDrawC(playersHands map[model.CellType][]model.CellPosition) (*model.GameResult, error)
}

type GameStateChecker struct{}

func NewGameStateChecker() GameStateCheckerB {
	return &GameStateChecker{}
}

func (gsc *GameStateChecker) CheckForVictoryOrDrawA(cells [][]*model.CellType) (*model.GameResult, error) {

	for _, combination := range WinningCombinationsForArray {
		a, b, c := combination[0], combination[1], combination[2]
		cell1 := cells[a/3][a%3]
		cell2 := cells[b/3][b%3]
		cell3 := cells[c/3][c%3]

		if cell1 != nil && *cell1 == *cell2 && *cell2 == *cell3 {
			return &model.GameResult{Winner: &model.PlayerType{Symbol: *cell1}, Draw: false}, nil
		}
	}

	cellAvailable := false
	for _, row := range cells {
		for _, cell := range row {
			if cell == nil {
				cellAvailable = true
				break
			}
		}
		if cellAvailable {
			break
		}
	}

	if cellAvailable {
		return nil, nil
	} else {
		return &model.GameResult{Winner: nil, Draw: true}, nil
	}

}

func (gsc *GameStateChecker) CheckForVictoryOrDrawB(cells map[model.CellPosition]*model.CellType) (*model.GameResult, error) {

	for _, combination := range WinningCombinationsForDictionary {
		pos1, pos2, pos3 := combination[0], combination[1], combination[2]
		cell1 := cells[pos1]
		cell2 := cells[pos2]
		cell3 := cells[pos3]

		if cell1 != nil && *cell1 == *cell2 && *cell2 == *cell3 {
			return &model.GameResult{Winner: &model.PlayerType{Symbol: *cell1}, Draw: false}, nil
		}
	}

	cellAvailable := false
	for _, cell := range cells {
		if cell == nil {
			cellAvailable = true
			break
		}
	}

	if cellAvailable {
		return nil, nil
	} else {
		return &model.GameResult{Winner: nil, Draw: true}, nil
	}

}

func (gsc *GameStateChecker) CheckForVictoryOrDrawC(playersMoves map[model.CellType][]model.CellPosition) (*model.GameResult, error) {

	playersSymbols := []model.CellType{model.X, model.O}

	for _, player := range playersSymbols {
		moves := playersMoves[player]
		for _, combination := range WinningCombinationsForDictionary {
			winning := true
			for _, pos := range combination {
				if !contains(moves, pos) {
					winning = false
					break
				}
			}
			if winning {
				return &model.GameResult{Winner: &model.PlayerType{Symbol: player}, Draw: false}, nil
			}
		}
	}

	totalMoves := 9 - len(playersMoves[model.X]) - len(playersMoves[model.O])
	if totalMoves > 0 {
		return nil, nil
	}
	return &model.GameResult{Winner: nil, Draw: true}, nil

}

func contains(arr []model.CellPosition, pos model.CellPosition) bool {
	for _, p := range arr {
		if p == pos {
			return true
		}
	}
	return false
}