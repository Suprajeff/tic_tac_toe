package responses

import (
	"encoding/json"
	"github.com/gorilla/websocket"
	"go-ttt/app/delivery/utils/responses/types"
	"net/http"
)

type GameResponses struct{}

func (gr GameResponses) sendResponse(res types.SChannel, data types.SData, statusCode interface{}, room *string) {
	switch channel := res.(type) {
	case *types.HttpResponseChannel:
		switch d := data.(type) {
		case *types.JsonData:
			if statusCode != nil {
				channel.Response.WriteHeader(int(statusCode.(types.ClientError)))
				json.NewEncoder(channel.Response).Encode(d.Data)
			} else {
				json.NewEncoder(channel.Response).Encode(d.Data)
			}
		case *types.HtmlData:
			if statusCode != nil {
				channel.Response.WriteHeader(int(statusCode.(types.ClientError)))
				channel.Response.Write([]byte(d.Data))
			} else {
				channel.Response.Write([]byte(d.Data))
			}
		}
	case *types.WebSocketChannel:
		switch d := data.(type) {
		case *types.JsonData:
			if room != nil {
//				channel.Socket.BroadcastJSON(*room, d.Data)
			} else {
				err := channel.Socket.WriteJSON(d.Data)
				if err != nil {
					return
				}
			}
		case *types.HtmlData:
			if room != nil {
//				channel.Socket.BroadcastText(*room, d.Data)
			} else {
				err := channel.Socket.WriteMessage(websocket.TextMessage, []byte(d.Data))
				if err != nil {
					return
				}
			}
		}
	}
}

func (gr *GameResponses) informationR(res types.SChannel, data types.SData, statusCode *types.Informational, room *string) {
	gr.sendResponse(res, data, statusCode, room)
}

func (gr *GameResponses) successR(res types.SChannel, data types.SData, statusCode *types.Success, room *string) {
	gr.sendResponse(res, data, statusCode, room)
}

func (gr *GameResponses) redirectionR(res types.SChannel, data types.SData, statusCode *types.Redirection, room *string) {
	gr.sendResponse(res, data, statusCode, room)
}

func (gr *GameResponses) clientErrR(res types.SChannel, data types.SData, statusCode *types.ClientError, room *string) {
	gr.sendResponse(res, data, statusCode, room)
}

func (gr *GameResponses) serverErrR(res types.SChannel, data types.SData, statusCode *types.ServerError, room *string) {
	gr.sendResponse(res, data, statusCode, room)
}

