package middlewares

import (
	"encoding/gob"
	"github.com/gorilla/sessions"
	"go-ttt/app/core/model"
)

func CreateCookieStore() *sessions.CookieStore {
	sessionKey := []byte("tictacgo")
	gob.Register(model.PlayerType{})
	gob.Register(model.GameState(""))
	gob.Register(model.BoardState{})
	gob.Register(model.MovesState{})
	gob.Register(model.ArrayBoard{})
	gob.Register(model.DictionaryBoard{})
	store := sessions.NewCookieStore(sessionKey)
	return store
}