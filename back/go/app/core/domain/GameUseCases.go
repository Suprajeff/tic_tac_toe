package repository

import (
	"context"
	"go-ttt/app/core/data/repository"
	"go-ttt/app/core/database/redis/entity"
	"go-ttt/app/core/model"
	service "go-ttt/app/core/service/game"
)

type GameUseCases interface {
	InitializeGame(ctx context.Context) (*model.GameType, error)
	ResetGame(ctx context.Context, gameID string) (*model.GameType, error)
	MakeMove(ctx context.Context, gameID string, position *model.CellPosition, player *model.PlayerType) (*model.GameType, error)
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

func (uc *GameUseCasesImpl) InitializeGame(ctx context.Context) (*model.GameType, error) {

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

func (uc *GameUseCasesImpl) ResetGame(ctx context.Context, gameID string) (*model.GameType, error) {

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

func (uc *GameUseCasesImpl) MakeMove(ctx context.Context, gameID string, position *model.CellPosition, player *model.PlayerType) (*model.GameType, error) {

	newBoardState, err := uc.gameRepo.UpdateBoard(ctx, gameID, position, player)
	if err != nil {
		return nil, err
	}

	result, err := uc.gameProcess.CheckForWinner(*newBoardState)
	if err != nil {
		return nil, err
	}

	nextPlayer, err := uc.gameProcess.GetNextPlayer(player)
	if err != nil {
		return nil, err
	}

	gameState := model.InProgress
	if result.Winner != nil {
		gameState = model.Won
	}
	if(result.Draw){
		gameState = model.Draw
	}

	var gameInfo = entity.GameInfo{
		GameState: gameState,
		CurrentPlayer: *nextPlayer,
		Winner: result.Winner,
	}

	return uc.gameRepo.UpdateGameState(ctx, gameID, newBoardState, &gameInfo)
}

