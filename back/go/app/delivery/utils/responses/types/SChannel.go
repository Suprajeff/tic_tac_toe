package types

import (
	"github.com/gorilla/websocket"
	"net/http"
)

type SChannel interface {
	isChannel()
}

type HttpResponseChannel struct {
	Response http.ResponseWriter
}

func (*HttpResponseChannel) isChannel() {}

type WebSocketChannel struct {
	Socket *websocket.Conn
}

func (*WebSocketChannel) isChannel() {}