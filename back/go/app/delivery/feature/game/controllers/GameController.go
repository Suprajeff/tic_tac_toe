package controllers

import (
	"encoding/json"
	repository "go-ttt/app/core/domain"
	"go-ttt/app/core/model"
	"go-ttt/app/delivery/utils/responses"
	"go-ttt/app/delivery/utils/responses/types"
	"net/http"
)

type GameController struct {
	useCases repository.GameUseCases
	sResponse responses.GameResponses
}

func NewGameController(gameUseCases repository.GameUseCases, gameResponses responses.GameResponses) *GameController {
	return &GameController{
		useCases: gameUseCases,
		sResponse: gameResponses,
	}
}

func (gc *GameController) HelloGo(w http.ResponseWriter, r *http.Request) {

	w.WriteHeader(http.StatusOK)
	w.Write([]byte("Hello, Go!"))

}

func (gc *GameController) StartGame(w http.ResponseWriter, r *http.Request) {

	ctx := r.Context()

	result, err := gc.useCases.InitializeGame(ctx)
	if err != nil {
		gc.handleError(w, err)
		return
	}

	gc.sendSuccessResponse(w, result)

}

func (gc *GameController) RestartGame(w http.ResponseWriter, r *http.Request) {

	ctx := r.Context()

	err := r.ParseForm()
	if err != nil {
		gc.handleError(w, err)
		return
	}

	gameID := r.FormValue("id")

	result, err := gc.useCases.ResetGame(ctx, gameID)
	if err != nil {
		gc.handleError(w, err)
		return
	}

	gc.sendSuccessResponse(w, result)

}

func (gc *GameController) MakeMove(w http.ResponseWriter, r *http.Request) {

	ctx := r.Context()

	err := r.ParseForm()
	if err != nil {
		gc.handleError(w, err)
		return
	}

	gameID := r.FormValue("id")
	positionData := r.FormValue("position")
	playerData := r.FormValue("player")

	var position model.CellPosition
	var player model.PlayerType

	if err := json.Unmarshal([]byte(positionData), &position); err != nil {
		gc.handleError(w, err)
		return
	}

	if err := json.Unmarshal([]byte(playerData), &player); err != nil {
		gc.handleError(w, err)
		return
	}

	result, err := gc.useCases.MakeMove(ctx, gameID, &position, &player)
	if err != nil {
		gc.handleError(w, err)
		return
	}

	gc.sendSuccessResponse(w, result)

}

func (gc *GameController) handleError(w http.ResponseWriter, err error) {
	var statusCode types.ServerError = types.InternalServerError
	gc.sResponse.ServerErrR(
		&types.HttpResponseChannel{Response: w},
		&types.JsonData{Data: nil},
		&statusCode,
		nil,
	)
}

func (gc *GameController) sendSuccessResponse(w http.ResponseWriter, data interface{}) {
	var statusCode types.Success = types.Ok
	gc.sResponse.SuccessR(
		&types.HttpResponseChannel{Response: w},
		&types.JsonData{Data: map[string]interface{}{"data": data}},
		&statusCode,
		nil,
	)
}

