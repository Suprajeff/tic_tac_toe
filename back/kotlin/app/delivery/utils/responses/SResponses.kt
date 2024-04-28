import io.ktor.server.*
import io.ktor.http.*

class GameResponses() {
    
    fun informationR(call: ApplicationCall, data: Any, statusCode: Status.Informational, format: Format, channel: Channel) {
        
    }
    
    fun successR(call: ApplicationCall, data: Any, statusCode: Status.Success, format: Format, channel: Channel) {
        
    }
    
    fun redirectionR(call: ApplicationCall, data: Any, statusCode: Status.Redirection, format: Format, channel: Channel) {
        
    }
    
    fun clientErrR(call: ApplicationCall, data: Any, statusCode: Status.ClientError, format: Format, channel: Channel) {
        
    }
    
    fun serverErrR(call: ApplicationCall, data: Any, statusCode: Status.ServerError, format: Format, channel: Channel) {
        
    }
}