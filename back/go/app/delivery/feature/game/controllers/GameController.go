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
		sResponse: gameResponses
	}
}

func (gc *GameController) StartGame(w http.ResponseWriter, r *http.Request) {

	ctx := r.Context()

	result, err := gc.useCases.InitializeGame(ctx)
	if err != nil {
		gc.sResponse.ServerErrR(
			&types.HttpResponseChannel{Response: w},
			&types.JsonData{Data: nil},
			types.INTERNAL_SERVER_ERROR,
			nil
		)
		return
	}

	gc.sResponse.SuccessR(
		&types.HttpResponseChannel{Response: w},
		&types.JsonData{Data: map[string]interface{}{"data": result}},
		&types.OK
	)

}

func (gc *GameController) RestartGame(w http.ResponseWriter, r *http.Request) {

	ctx := r.Context()

	err := r.ParseForm()
	if err != nil {
		http.Error(w, "Failed to parse form data", http.StatusInternalServerError)
		return
	}

	gameID := r.FormValue("id")

	result, err := gc.useCases.ResetGame(ctx, gameID)
	if err != nil {
		gc.sResponse.ServerErrR(
			&types.HttpResponseChannel{Response: w},
			&types.JsonData{Data: nil},
			types.INTERNAL_SERVER_ERROR,
			nil
		)
		return
	}

	gc.sResponse.SuccessR(
		&types.HttpResponseChannel{Response: w},
		&types.JsonData{Data: map[string]interface{}{"data": result}},
		&types.OK,
		nil
	)


}

func (gc *GameController) MakeMove(w http.ResponseWriter, r *http.Request) {

	ctx := r.Context()

	err := r.ParseForm()
	if err != nil {
		http.Error(w, "Failed to parse form data", http.StatusInternalServerError)
		return
	}

	gameID := r.FormValue("id")
	positionData := r.FormValue("position")
	playerData := r.FormValue("player")

	var position model.CellPosition
	var player model.PlayerType

	if err := json.Unmarshal([]byte(positionData), &position); err != nil {
		http.Error(w, "Failed to unmarshal position data", http.StatusInternalServerError)
		return
	}

	if err := json.Unmarshal([]byte(playerData), &player); err != nil {
		http.Error(w, "Failed to unmarshal player data", http.StatusInternalServerError)
		return
	}

	result, err := gc.useCases.MakeMove(ctx, gameID, &position, &player)
	if err != nil {
		gc.sResponse.serverErrR(
			&types.HttpResponseChannel{Response: w},
			&types.JsonData{Data: nil},
			types.INTERNAL_SERVER_ERROR,
			nil,
		)
		return
	}

	gc.sResponse.successR(
		&types.HttpResponseChannel{Response: w},
		&types.JsonData{Data: map[string]interface{}{"data": result}},
		statusCode: types.OK,
		room:       nil,
	)

}

