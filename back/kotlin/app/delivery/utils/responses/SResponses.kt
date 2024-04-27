import io.ktor.server.application.*

class GameResponses() {
    
    fun informationR(res: Call, data: Any, statusCode: Status.Informational, format: Format, channel: Channel) {
        
    }
    
    fun successR(res: Call, data: Any, statusCode: Status.Success, format: Format, channel: Channel) {
        
    }
    
    fun redirectionR(res: Call, data: Any, statusCode: Status.Redirection, format: Format, channel: Channel) {
        
    }
    
    fun clientErrR(res: Call, data: Any, statusCode: Status.ClientError, format: Format, channel: Channel) {
        
    }
    
    fun serverErrR(res: Call, data: Any, statusCode: Status.ServerError, format: Format, channel: Channel) {
        
    }
}