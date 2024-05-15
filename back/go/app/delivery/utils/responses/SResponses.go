package responses

import (
	"encoding/json"
	"github.com/gorilla/websocket"
	"go-ttt/app/delivery/utils/responses/types"
	"net/http"
)

type GameResponses struct{}

func NewGameResponses() GameResponses {
	return GameResponses{}
}

func (gr GameResponses) sendHTTPResponse(w http.ResponseWriter, data interface{}, statusCode int) {
	switch v := data.(type) {
	case string:
		w.Header().Set("Content-Type", "text/html")
		w.WriteHeader(statusCode)
		w.Write([]byte(v))
	default:
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(statusCode)
		json.NewEncoder(w).Encode(data)
	}
}

func (gr GameResponses) sendSocketResponse(conn *websocket.Conn, data interface{}, room string) error {
	var err error

	switch v := data.(type) {
	case string:
		if room != "" {
			// Broadcast the string data to the specified room
			err = gr.broadcastToRoom(room, websocket.TextMessage, []byte(v))
		} else {
			// Send the string data to the current WebSocket connection
			err = conn.WriteMessage(websocket.TextMessage, []byte(v))
		}
	default:
		bytes, marshalErr := json.Marshal(v)
		if marshalErr != nil {
			return marshalErr
		}

		if room != "" {
			// Broadcast the JSON data to the specified room
			err = gr.broadcastToRoom(room, websocket.TextMessage, bytes)
		} else {
			// Send the JSON data to the current WebSocket connection
			err = conn.WriteMessage(websocket.TextMessage, bytes)
		}
	}

	return err
}

func (gr GameResponses) broadcastToRoom(room string, messageType int, message []byte) error {
	// Broadcast the message to WebSocket connections in the specified room
	return nil
}

func (gr *GameResponses) informationR(w http.ResponseWriter, data interface{}, statusCode types.Informational) {
	gr.sendHTTPResponse(w, data, int(statusCode))
}

func (gr *GameResponses) SuccessR(w http.ResponseWriter, data interface{}, statusCode types.Success) {
	gr.sendHTTPResponse(w, data, int(statusCode))
}

func (gr *GameResponses) redirectionR(w http.ResponseWriter, data interface{}, statusCode types.Redirection) {
	gr.sendHTTPResponse(w, data, int(statusCode))
}

func (gr *GameResponses) clientErrR(w http.ResponseWriter, data interface{}, statusCode types.ClientError) {
	gr.sendHTTPResponse(w, data, int(statusCode))
}

func (gr *GameResponses) ServerErrR(w http.ResponseWriter, data interface{}, statusCode types.ServerError) {
	gr.sendHTTPResponse(w, data, int(statusCode))
}

func (gr *GameResponses) SocketR(socket *websocket.Conn, data interface{}, room *string) {
	gr.sendSocketResponse(socket, data, *room)
}

