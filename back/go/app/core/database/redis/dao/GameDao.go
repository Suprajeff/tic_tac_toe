package dao

import (
	"context"
	"fmt"
	redisInstance "go-ttt/app/core/database/redis"
	"go-ttt/app/core/database/redis/entity"
	"go-ttt/app/core/database/redis/util"
	"go-ttt/app/core/model"
)

type GameDao struct {
	*redisInstance.Data
}

type GameDaoProtocol interface {
	SetGame(ctx context.Context, newKey string, board model.StateType, player model.PlayerType) (*model.GameType, error)
	ResetGame(ctx context.Context, gameID string, board model.StateType, player model.PlayerType) (*model.GameType, error)
	AddPlayerMove(ctx context.Context, gameID string, move entity.Move) (*model.StateType, error)
	GetPlayerMoves(ctx context.Context, gameID string, move entity.Move) (*entity.Moves, error)
	GetInfo(ctx context.Context, gameID string) (*model.GameType, error)
	UpdateInfo(ctx context.Context, gameID string, board model.StateType, info entity.GameInfo) (*model.GameType, error)
}

func NewGameDao(rData *redisInstance.Data) GameDao {
	return GameDao{Data:rData}
}

func (dao *GameDao) SetGame(ctx context.Context, newKey string, board model.StateType, player model.PlayerType) (*model.GameType, error) {

	key := fmt.Sprintf("%s:info", newKey)
	playerAsString := util.PlayerTypeToString(player)
	gameStateString := util.GameStateToString(model.InProgress)

	err := dao.Redis.HMSet(ctx, key, map[string]interface{}{
		"currentPlayer": playerAsString,
		"gameState":     gameStateString,
	}).Err()
	if err != nil {
		return nil, err
	}

	return &model.GameType{
		ID:    newKey,
		CurrentPlayer: player,
		GameState: model.InProgress,
		State: board,
		Winner: nil,
	}, nil

}

func (dao *GameDao) ResetGame(ctx context.Context, gameID string, board model.StateType, player model.PlayerType) (*model.GameType, error) {

	_, err := dao.Redis.Del(ctx, fmt.Sprintf("%s:moves:X", gameID), fmt.Sprintf("%s:moves:O", gameID)).Result()
	if err != nil {
		return nil, err
	}

	_, err = dao.Redis.HDel(ctx, fmt.Sprintf("%s:info", gameID), "winner").Result()
	if err != nil {
		return nil, err
	}

	playerAsString := util.PlayerTypeToString(player)
	gameStateString := util.GameStateToString(model.InProgress)

	err = dao.Redis.HMSet(ctx, fmt.Sprintf("%s:info", gameID), map[string]interface{}{
		"currentPlayer": playerAsString,
		"gameState":     gameStateString,
	}).Err()
	if err != nil {
		return nil, err
	}

	return &model.GameType{
		ID:    gameID,
		CurrentPlayer: player,
		GameState: model.InProgress,
		State: board,
		Winner: nil,
	}, nil

}

func (dao *GameDao) AddPlayerMove(ctx context.Context, gameID string, move entity.Move) (*model.StateType, error) {

	playerAsString := util.PlayerTypeToString(move.Player)

	cellPositionAsString, err := util.CellPositionToString(move.Position)
	if err != nil {
		fmt.Println(err.Error())
		return nil, err
	}

	err = dao.Redis.SAdd(ctx, fmt.Sprintf("%s:moves:%s", gameID, playerAsString), cellPositionAsString).Err()
	if err != nil {
		fmt.Println("Error Redis SAdd")
		return nil, err
	}

	xPositions, err := dao.Redis.SMembers(ctx, fmt.Sprintf("%s:moves:X", gameID)).Result()
	if err != nil {
		fmt.Println("Error Redis SMembers 1")
		return nil, err
	}

	oPositions, err := dao.Redis.SMembers(ctx, fmt.Sprintf("%s:moves:O", gameID)).Result()
	if err != nil {
		fmt.Println("Error Redis SMembers 2")
		return nil, err
	}

	xCellPositions := make([]model.CellPosition, len(xPositions))
	for i, pos := range xPositions {
		xCellPositions[i], err = util.StringToCellPosition(pos)
		if err != nil {
			fmt.Println("Error Redis Cell Position X")
			return nil, err
		}
	}

	oCellPositions := make([]model.CellPosition, len(oPositions))
	for i, pos := range oPositions {
		oCellPositions[i], err = util.StringToCellPosition(pos)
		if err != nil {
			fmt.Println("Error Redis Cell Position O")
			return nil, err
		}
	}

	playersMoves := model.PlayersMoves{
		model.X: xCellPositions,
		model.O: oCellPositions,
	}

	state := model.MovesState{PlayersMoves: playersMoves}

	var stateAsStateType model.StateType = state

	return &stateAsStateType, nil
}

func (dao *GameDao) GetPlayerMoves(ctx context.Context, gameID string, move entity.Move) (*entity.Moves, error) {

	playerAsString := util.PlayerTypeToString(move.Player)

	key := fmt.Sprintf("%s:moves:%s", gameID, playerAsString)

	positions, err := dao.Redis.SMembers(ctx, key).Result()
	if err != nil {
		return nil, err
	}

	cellPositions := make([]model.CellPosition, len(positions))
	for i, pos := range positions {
		cellPositions[i], err = util.StringToCellPosition(pos)
		if err != nil {
			return nil, err
		}
	}

	return &entity.Moves{
		Player:    move.Player,
		Positions: cellPositions,
	}, nil
}

func (dao *GameDao) GetInfo(ctx context.Context, gameID string) (*model.GameType, error) {

	info, err := dao.Redis.HMGet(ctx, fmt.Sprintf("%s:info", gameID), "currentPlayer", "gameState", "winner").Result()
	if err != nil {
		fmt.Println(err.Error())
		return nil, err
	}

	var values []string

	for _, value := range info {
		// is string ?
		if strValue, ok := value.(string); ok {
			values = append(values, strValue)
		} else {
			fmt.Println("Value is not a string")
		}
	}

	currentPlayerData, err := util.StringToPlayerType(values[0])
	if err != nil {
		fmt.Println(err.Error())
		return nil, err
	}

	gameStateData, err := util.StringToGameState(values[1])
	if err != nil {
		fmt.Println(err.Error())
		return nil, err
	}

	winnerData, err := util.StringToPlayerType(values[2])
	if err != nil {
		fmt.Println(err.Error())
		return nil, err
	}

	xPositions, err := dao.Redis.SMembers(ctx, fmt.Sprintf("%s:moves:X", gameID)).Result()
	if err != nil {
		fmt.Println(err.Error())
		return nil, err
	}

	oPositions, err := dao.Redis.SMembers(ctx, fmt.Sprintf("%s:moves:O", gameID)).Result()
	if err != nil {
		fmt.Println(err.Error())
		return nil, err
	}

	xCellPositions := make([]model.CellPosition, len(xPositions))
	for i, pos := range xPositions {
		xCellPositions[i], err = util.StringToCellPosition(pos)
		if err != nil {
			fmt.Println(err.Error())
			return nil, err
		}
	}

	oCellPositions := make([]model.CellPosition, len(oPositions))
	for i, pos := range oPositions {
		oCellPositions[i], err = util.StringToCellPosition(pos)
		if err != nil {
			fmt.Println(err.Error())
			return nil, err
		}
	}

	playersMoves := model.PlayersMoves{
		model.X: xCellPositions,
		model.O: oCellPositions,
	}

	state := model.MovesState{PlayersMoves: playersMoves}

	var stateAsStateType model.StateType = &state

	return &model.GameType{
		ID: gameID,
		CurrentPlayer: *currentPlayerData,
		GameState:     gameStateData,
		State: stateAsStateType,
		Winner:        winnerData,
	}, nil
}

func (dao *GameDao) UpdateInfo(ctx context.Context, gameID string, board model.StateType, info entity.GameInfo) (*model.GameType, error) {

	key := fmt.Sprintf("%s:info", gameID)

	playerAsString := util.PlayerTypeToString(info.CurrentPlayer)
	gameStateString := util.GameStateToString(info.GameState)
	var winner *model.PlayerType = nil
	winnerAsString := ""

	if info.Winner != nil {
		winner = info.Winner
		winnerAsString = util.PlayerTypeToString(*info.Winner)
	}

	err := dao.Redis.HMSet(ctx, key, map[string]interface{}{
		"currentPlayer": playerAsString,
		"gameState":     gameStateString,
		"winner":        winnerAsString,
	}).Err()
	if err != nil {
		return nil, err
	}

	return &model.GameType{
		ID: gameID,
		CurrentPlayer: info.CurrentPlayer,
		GameState: info.GameState,
		State: board,
		Winner: winner,
	}, nil
}

