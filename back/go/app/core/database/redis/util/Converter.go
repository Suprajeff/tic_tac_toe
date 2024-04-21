package util

import (
	"errors"
	"go-ttt/app/core/model"
)

func CellPositionToString(position model.CellPosition) (string, error) {
	switch position {
	case model.TL:
		return "TL", nil
	case model.T:
		return "T", nil
	case model.TR:
		return "TR", nil
	case model.L:
		return "L", nil
	case model.C:
		return "C", nil
	case model.R:
		return "R", nil
	case model.BL:
		return "BL", nil
	case model.B:
		return "B", nil
	case model.BR:
		return "BR", nil
	default:
		return "", errors.New("invalid CellPosition")
	}
}

func StringToCellPosition(s string) (model.CellPosition, error) {
	switch s {
	case "TL":
		return model.TL, nil
	case "T":
		return model.T, nil
	case "TR":
		return model.TR, nil
	case "L":
		return model.L, nil
	case "C":
		return model.C, nil
	case "R":
		return model.R, nil
	case "BL":
		return model.BL, nil
	case "B":
		return model.B, nil
	case "BR":
		return model.BR, nil
	default:
		return "", errors.New("invalid CellPosition string")
	}
}

func PlayerTypeToString(playerType model.PlayerType) string {
	return string(playerType.Symbol)
}

func StringToPlayerType(s string) (model.PlayerType, error) {
	switch s {
	case string(model.X):
		return model.PlayerType{Symbol: model.X}, nil
	case string(model.O):
		return model.PlayerType{Symbol: model.O}, nil
	default:
		return model.PlayerType{}, errors.New("invalid PlayerType string")
	}
}

func GameStateToString(gameState model.GameState) string {
	return string(gameState)
}

func StringToGameState(s string) (model.GameState, error) {
	switch s {
	case string(model.InProgress):
		return model.InProgress, nil
	case string(model.Won):
		return model.Won, nil
	case string(model.Draw):
		return model.Draw, nil
	default:
		return "", errors.New("invalid GameState string")
	}
}