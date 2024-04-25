package repository

import (
	"context"
	"go-ttt/app/core/data/repository"
	"go-ttt/app/core/database/redis/entity"
	"go-ttt/app/core/model"
	service "go-ttt/app/core/service/gameLogic"
)

type GameUseCases interface {
	initializeGame(ctx context.Context) (*model.GameType, error)
	resetGame(ctx context.Context, gameID string) (*model.GameType, error)
	makeMove(ctx context.Context, gameID string, position *model.CellPosition, player *model.PlayerType) (*model.GameType, error)
}
type GameUseCasesImpl struct {
	gameRepo repository.GameRepository
	gameProcess service.GameLogicB
}

func NewGameUseCases(repo repository.GameRepository, logic service.GameLogicB) GameUseCases {
	return &GameUseCasesImpl{
		gameRepo: repo,
		gameProcess: logic,
	}
}

func (uc *GameUseCasesImpl) initializeGame(ctx context.Context) (*model.GameType, error) {

	newKey, err := uc.gameProcess.GenerateNewID()
	if err != nil {
		return nil, err
	}
	board, err := uc.gameProcess.GenerateNewBoard()
	if err != nil {
		return nil, err
	}

	var boardState = model.BoardState{
		BoardType: *board,
	}

	var boardStateAsStateType model.StateType = &boardState

	player, err := uc.gameProcess.RandomPlayer()
	if err != nil {
		return nil, err
	}

	return uc.gameRepo.CreateNewGame(ctx, newKey, &boardStateAsStateType, player)
}

func (uc *GameUseCasesImpl) resetGame(ctx context.Context, gameID string) (*model.GameType, error) {

	board, err := uc.gameProcess.GenerateNewBoard()
	if err != nil {
		return nil, err
	}

	var boardState = model.BoardState{
			BoardType: *board,
		}

	var boardStateAsStateType model.StateType = &boardState

	player, err := uc.gameProcess.RandomPlayer()
	if err != nil {
		return nil, err
	}

	return uc.gameRepo.ResetGame(ctx, gameID, &boardStateAsStateType, player)
}

func (uc *GameUseCasesImpl) makeMove(ctx context.Context, gameID string, position *model.CellPosition, player *model.PlayerType) (*model.GameType, error) {

	newBoardState, err := uc.gameRepo.UpdateBoard(ctx, gameID, position, player)
	if err != nil {
		return nil, err
	}

	victory, winner, err := uc.gameProcess.CheckForWinner(*newBoardState)
	if err != nil {
		return nil, err
	}

	nextPlayer, err := uc.gameProcess.GetNextPlayer(player)
	if err != nil {
		return nil, err
	}

	gameState := model.InProgress
	if victory {
		gameState = model.Won
	}

	var gameInfo = entity.GameInfo{
		GameState: gameState,
		CurrentPlayer: *nextPlayer,
		Winner: winner,
	}

	return uc.gameRepo.UpdateGameState(ctx, gameID, newBoardState, &gameInfo)
}

