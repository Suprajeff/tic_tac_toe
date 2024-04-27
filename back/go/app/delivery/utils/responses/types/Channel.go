package types

type Channel string

const (
	HTTP Channel = "http"
	SOCKETIO Channel = "socket.io"
)