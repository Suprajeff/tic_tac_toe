package controllers

import (
	"errors"
	"fmt"
	"github.com/gorilla/sessions"
	"go-ttt/app/core/database/redis/util"
	repository "go-ttt/app/core/domain"
	"go-ttt/app/core/model"
	"go-ttt/app/delivery/feature/game/content"
	contentType "go-ttt/app/delivery/feature/game/content/types"
	"go-ttt/app/delivery/utils/responses"
	"go-ttt/app/delivery/utils/responses/types"
	"net/http"
)

type GameController struct {
	useCases repository.GameUseCases
	sResponse responses.GameResponses
	sessionStore *sessions.CookieStore
}

func NewGameController(gameUseCases repository.GameUseCases, gameResponses responses.GameResponses, store *sessions.CookieStore) *GameController {
	return &GameController{
		useCases: gameUseCases,
		sResponse: gameResponses,
		sessionStore: store,
	}
}

func (gc *GameController) HelloGo(w http.ResponseWriter, r *http.Request) {

	w.WriteHeader(http.StatusOK)
	w.Write([]byte("Hello, Go!"))

}

func (gc *GameController) StartGame(w http.ResponseWriter, r *http.Request) {

	fmt.Println("Starting Game")
	ctx := r.Context()
	resultCh := make(chan *model.GameType)
	errorCh := make(chan error)

	go func() {
		result, err := gc.useCases.InitializeGame(ctx)
		if err != nil {
			errorCh <- err
			return
		}
		resultCh <- result
	}()

	select {
	    case result := <-resultCh:
			fmt.Println("Result Creation Log", result)
			gc.saveResult(w, r, result)
			var boardHtml = content.GetNewBoard()
			gc.sendSuccessResponse(w, boardHtml)
		case err := <-errorCh:
			fmt.Println(err.Error())
			gc.handleError(w, err)
		case <-ctx.Done():
			gc.handleError(w, ctx.Err())
	}

}

func (gc *GameController) RestartGame(w http.ResponseWriter, r *http.Request) {

	ctx := r.Context()
	resultCh := make(chan *model.GameType)
	errorCh := make(chan error)

    go func() {
        game, err := gc.retrieveSavedResult(w, r)
		if err != nil {
			errorCh <- err
			return
		}

		result, err := gc.useCases.ResetGame(ctx, game.ID)
		if err != nil {
			errorCh <- err
			return
		}
		resultCh <- result
	}()

    select {
	    case result := <-resultCh:
	        fmt.Println("Result Restart Log", result)
			gc.saveResult(w, r, result)
			var boardHtml = content.GetNewBoard()
			gc.sendSuccessResponse(w, boardHtml)
		case err := <-errorCh:
			gc.handleError(w, err)
		case <-ctx.Done():
			gc.handleError(w, ctx.Err())
	}

}

func (gc *GameController) MakeMove(w http.ResponseWriter, r *http.Request) {

	ctx := r.Context()

	err := r.ParseForm()
	if err != nil {
		fmt.Println(err.Error())
		gc.handleError(w, err)
		return
	}

	resultCh := make(chan *model.GameType)
	errorCh := make(chan error)

    go func() {
        game, err := gc.retrieveSavedResult(w, r)
		if err != nil {
			errorCh <- err
			return
		}

		positionData := r.FormValue("position")
		position, err := util.StringToCellPosition(positionData)
		if err != nil {
			errorCh <- err
			return
		}

		player := model.PlayerType{
			Symbol: game.CurrentPlayer.Symbol,
		}

		result, err := gc.useCases.MakeMove(ctx, game.ID, position, player)
		if err != nil {
			errorCh <- err
			return
		}
		resultCh <- result
	}()


	select {
		case result := <-resultCh:
			fmt.Println("Result Restart Log", result)
			gc.saveResult(w, r, result)

			var newTitle contentType.GameTitle

			switch result.GameState {
			case "WON":
				if result.Winner.Symbol == model.X {
					newTitle = contentType.PlayerXWon
				} else {
					newTitle = contentType.PlayerOWon
				}
			case "DRAW":
				newTitle = contentType.Draw
			default:
				newTitle = contentType.Playing
			}

			switch state := result.State.(type) {
			case model.BoardState:
				gc.handleError(w, errors.New("wrong type"))
				return
			case model.MovesState:
				var boardHtml = content.GetBoard(newTitle, state.PlayersMoves)
				gc.sendSuccessResponse(w, boardHtml)
			}
		case err := <-errorCh:
			gc.handleError(w, err)
		case <-ctx.Done():
			gc.handleError(w, ctx.Err())
	}

}

func (gc *GameController) retrieveSavedResult(w http.ResponseWriter, r *http.Request) (*model.GameType, error) {

	session, err := gc.sessionStore.Get(r, "tictacgo")
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return nil, err
	}

	gameID, ok := session.Values["gameID"].(string)
	if !ok {
		return nil, errors.New("gameID is nil")
	}

	player, ok := session.Values["currentPlayer"].(model.PlayerType)
	if !ok {
		return nil, errors.New("gameID is nil")
	}

	gameState, ok := session.Values["gameState"].(model.GameState)
	if !ok {
		return nil, errors.New("gameID is nil")
	}

	state, ok := session.Values["state"].(model.StateType)
	if !ok {
		return nil, errors.New("gameID is nil")
	}

	return &model.GameType{
		ID:    gameID,
		CurrentPlayer: player,
		GameState: gameState,
		State: state,
		Winner: nil,
	}, nil

}

func (gc *GameController) saveResult(w http.ResponseWriter, r *http.Request, result *model.GameType) {

	session, err := gc.sessionStore.Get(r, "tictacgo")
	if err != nil {
		fmt.Println(err.Error())
		return
	}

	session.Values["gameID"] = result.ID
	session.Values["currentPlayer"] = result.CurrentPlayer
	session.Values["gameState"] = result.GameState
	session.Values["state"] = result.State

	err = session.Save(r, w)
	if err != nil {
		fmt.Println(err.Error())
		return
	}

}

func (gc *GameController) handleError(w http.ResponseWriter, err error) {
	var statusCode types.ServerError = types.InternalServerError
	gc.sResponse.ServerErrR(
		w,
		&types.JsonData{Data: nil},
		statusCode,
	)
}

func (gc *GameController) sendSuccessResponse(w http.ResponseWriter, data interface{}) {
	var statusCode types.Success = types.Ok
	gc.sResponse.SuccessR(
		w,
		data,
		statusCode,
	)
}

