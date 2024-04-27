package responses

import "go-ttt/app/delivery/utils/responses/types"

type GameResponses struct{}

func (gr *GameResponses) informationR(res Response, data interface{}, statusCode types.Informational, format types.Format, channel types.Channel) {
	
}

func (gr *GameResponses) successR(res Response, data interface{}, statusCode types.Success, format types.Format, channel types.Channel) {
	
}

func (gr *GameResponses) redirectionR(res Response, data interface{}, statusCode types.Redirection, format types.Format, channel types.Channel) {
	
}

func (gr *GameResponses) clientErrR(res Response, data interface{}, statusCode types.ClientError, format types.Format, channel types.Channel) {
	
}

func (gr *GameResponses) serverErrR(res Response, data interface{}, statusCode types.ServerError, format types.Format, channel types.Channel) {
	
}

