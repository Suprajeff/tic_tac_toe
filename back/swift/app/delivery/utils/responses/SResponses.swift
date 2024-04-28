import Vapor

class GameResponses {
    
    func informationR(res: Response, data: Any, statusCode: Status.Informational, room: string) {
        
    }
    
    func successR(res: Response, data: Any, statusCode: Status.Success, room: string) {
        
    }
    
    func redirectionR(res: Response, data: Any, statusCode: Status.Redirection, room: string) {
        
    }
    
    func clientErrR(res: Response, data: Any, statusCode: Status.ClientError, room: string) {
        
    }
    
    func serverErrR(res: Response, data: Any, statusCode: Status.ServerError, room: string) {
        
    }
}

