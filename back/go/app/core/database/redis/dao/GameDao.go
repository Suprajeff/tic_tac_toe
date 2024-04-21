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
	setGame(ctx context.Context, newKey string, board *model.BoardType, player *model.PlayerType) (*model.GameType, error)
	resetGame(ctx context.Context, gameID string, board *model.BoardType, player *model.PlayerType) (*model.GameType, error)
	addPlayerMove(ctx context.Context, gameID string, move *entity.Move) (*entity.Moves, error)
	getPlayerMoves(ctx context.Context, gameID string, move *entity.Move) (*entity.Moves, error)
	getInfo(ctx context.Context, gameID string) (*entity.GameInfo, error)
	updateInfo(ctx context.Context, gameID string, info *entity.GameInfo) (*entity.GameInfo, error)
}

func (dao *GameDao) setGame(ctx context.Context, newKey string, board *model.BoardType, player *model.PlayerType) (*model.GameType, error) {

	key := fmt.Sprintf("%s:info", newKey)

	err := dao.Redis.HMSet(ctx, key, map[string]interface{}{
		"currentPlayer": player,
		"gameState":     "IN_PROGRESS",
	}).Err()
	if err != nil {
		return nil, err
	}

	return &model.GameType{
		ID:    newKey,
		Board: *board,
		CurrentPlayer: *player,
		GameState: model.InProgress,
		Winner: nil,
	}, nil

}

func (dao *GameDao) resetGame(ctx context.Context, gameID string, board *model.BoardType, player *model.PlayerType) (*model.GameType, error) {

	_, err := dao.Redis.Del(ctx, fmt.Sprintf("%s:moves:X", gameID), fmt.Sprintf("%s:moves:O", gameID)).Result()
	if err != nil {
		return nil, err
	}

	_, err = dao.Redis.HDel(ctx, fmt.Sprintf("%s:info", gameID), "winner").Result()
	if err != nil {
		return nil, err
	}

	err = dao.Redis.HMSet(ctx, fmt.Sprintf("%s:info", gameID), map[string]interface{}{
		"currentPlayer": player,
		"gameState":     "IN_PROGRESS",
	}).Err()
	if err != nil {
		return nil, err
	}

	return &model.GameType{
		ID:    gameID,
		Board: *board,
		CurrentPlayer: *player,
		GameState: model.InProgress,
		Winner: nil,
	}, nil

}

func (dao *GameDao) addPlayerMove(ctx context.Context, gameID string, move entity.Move) (entity.Moves, error) {

	key := fmt.Sprintf("%s:moves:%s", gameID, move.Player)

	err := dao.Redis.SAdd(ctx, key, string(move.Position)).Err()
	if err != nil {
		return entity.Moves{}, err
	}

	positions, err := dao.Redis.SMembers(ctx, key).Result()
	if err != nil {
		return entity.Moves{}, err
	}

	cellPositions := make([]model.CellPosition, len(positions))
	for i, pos := range positions {
		cellPositions[i], err = util.StringToCellPosition(pos)
		if err != nil {
			return entity.Moves{}, err
		}
	}

	return entity.Moves{
		Player:    move.Player,
		Positions: cellPositions,
	}, nil
}

func (dao *GameDao) getPlayerMoves(ctx context.Context, gameID string, move entity.Move) (entity.Moves, error) {

	key := fmt.Sprintf("%s:moves:%s", gameID, move.Player)

	positions, err := dao.Redis.SMembers(ctx, key).Result()
	if err != nil {
		return entity.Moves{}, err
	}

	cellPositions := make([]model.CellPosition, len(positions))
	for i, pos := range positions {
		cellPositions[i], err = util.StringToCellPosition(pos)
		if err != nil {
			return entity.Moves{}, err
		}
	}

	return entity.Moves{
		Player:    move.Player,
		Positions: cellPositions,
	}, nil
}

func (dao *GameDao) getInfo(ctx context.Context, gameID string) (*entity.GameInfo, error) {

	key := fmt.Sprintf("%s:info", gameID)

	info, err := dao.Redis.HMGet(ctx, key, "currentPlayer", "gameState", "winner").Result()
	if err != nil {
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
		return nil, err
	}

	gameStateData, err := util.StringToGameState(values[1])
	if err != nil {
		return nil, err
	}

	winnerData, err := util.StringToPlayerType(values[2])
	if err != nil {
		return nil, err
	}

	return &entity.GameInfo{
		CurrentPlayer: *currentPlayerData,
		GameState:     gameStateData,
		Winner:        winnerData,
	}, nil
}

func (dao *GameDao) updateInfo(ctx context.Context, gameID string, info *entity.GameInfo) (*entity.GameInfo, error) {

	key := fmt.Sprintf("%s:info", gameID)

	err := dao.Redis.HMSet(ctx, key, map[string]interface{}{
		"currentPlayer": info.CurrentPlayer,
		"gameState":     info.GameState,
		"winner":        info.Winner,
	}).Err()
	if err != nil {
		return nil, err
	}

	return info, nil
}

