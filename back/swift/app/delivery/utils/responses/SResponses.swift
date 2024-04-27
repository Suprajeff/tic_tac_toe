import Vapor

class GameResponses {
    
    func informationR(res: Response, data: Any, statusCode: Status.Informational, format: Format, channel: Channel) {
        
    }
    
    func successR(res: Response, data: Any, statusCode: Status.Success, format: Format, channel: Channel) {
        
    }
    
    func redirectionR(res: Response, data: Any, statusCode: Status.Redirection, format: Format, channel: Channel) {
        
    }
    
    func clientErrR(res: Response, data: Any, statusCode: Status.ClientError, format: Format, channel: Channel) {
        
    }
    
    func serverErrR(res: Response, data: Any, statusCode: Status.ServerError, format: Format, channel: Channel) {
        
    }
}

