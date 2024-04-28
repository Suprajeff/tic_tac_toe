package responses

import (
	"net/http"
	"go-ttt/app/delivery/utils/responses/types"
)

type GameResponses struct{}

func (gr *GameResponses) informationR(res http.ResponseWriter, data interface{}, statusCode types.Informational, format types.Format, channel types.Channel) {
	
}

func (gr *GameResponses) successR(res http.ResponseWriter, data interface{}, statusCode types.Success, format types.Format, channel types.Channel) {
	
}

func (gr *GameResponses) redirectionR(res http.ResponseWriter, data interface{}, statusCode types.Redirection, format types.Format, channel types.Channel) {
	
}

func (gr *GameResponses) clientErrR(res http.ResponseWriter, data interface{}, statusCode types.ClientError, format types.Format, channel types.Channel) {
	
}

func (gr *GameResponses) serverErrR(res http.ResponseWriter, data interface{}, statusCode types.ServerError, format types.Format, channel types.Channel) {
	
}

