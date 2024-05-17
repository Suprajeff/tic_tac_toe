import io.ktor.http.HttpStatusCode
import io.ktor.http.ContentType
import io.ktor.server.response.respondText
import io.ktor.server.application.*
import io.ktor.http.*
import io.ktor.server.*
import io.ktor.websocket.*

class GameResponses() {
    
    private suspend fun sendHTTPResponse(res: ApplicationCall, data: SData, statusCode: HttpStatusCode) {
        when (data) {
            is SData.Json -> {
                res.call.respondText(data.data.toString(), contentType = ContentType.Application.Json, status = statusCode)
            }
            is SData.Html -> {
                res.call.respondText(data.data, contentType = ContentType.Text.Html, status = statusCode)
            }
        }
    }

    private suspend fun sendSocketResponse(res: WebSocketSession, data: SData, room: String? = null) {
        when (data) {
            is SData.Json -> {
                if (room != null) {
                    // need to implement logic to send to all connected users
//                            res.session.broadcast(data.data.toString(), room)
                } else {
                    res.session.send(Frame.Text(data.data.toString()))
                }
            }
            is SData.Html -> {
                if (room != null) {
                // need to implement logic to send to all connected users
                    //res.session.broadcast(data.data, room)
                } else {
                    res.session.send(Frame.Text(data.data.toString()))
                }
            }
        }
    }

    suspend fun informationR(res: ApplicationCall, data: SData, statusCode: Status.Informational) {
        sendHTTPResponse(res, data, statusCode.toHttpStatusCode(), room)
    }

    suspend fun successR(res: ApplicationCall, data: SData, statusCode: Status.Success) {
        sendHTTPResponse(res, data, statusCode.toHttpStatusCode(), room)
    }

    suspend fun redirectionR(res: ApplicationCall, data: SData, statusCode: Status.Redirection) {
        sendHTTPResponse(res, data, statusCode.toHttpStatusCode(), room)
    }

    suspend fun clientErrR(res: ApplicationCall, data: SData, statusCode: Status.ClientError) {
        sendHTTPResponse(res, data, statusCode.toHttpStatusCode(), room)
    }

    suspend fun serverErrR(res: ApplicationCall, data: SData, statusCode: Status.ServerError) {
        sendHTTPResponse(res, data, statusCode.toHttpStatusCode(), room)
    }

    suspend fun socketR(res: WebSocketSession, data: SData, room: String? = null) {
        sendHTTPResponse(res, data, statusCode.toHttpStatusCode(), room)
    }

}

fun Status.Informational.toHttpStatusCode(): HttpStatusCode = HttpStatusCode.fromValue(this.value)
fun Status.Success.toHttpStatusCode(): HttpStatusCode = HttpStatusCode.fromValue(this.value)
fun Status.Redirection.toHttpStatusCode(): HttpStatusCode = HttpStatusCode.fromValue(this.value)
fun Status.ClientError.toHttpStatusCode(): HttpStatusCode = HttpStatusCode.fromValue(this.value)
fun Status.ServerError.toHttpStatusCode(): HttpStatusCode = HttpStatusCode.fromValue(this.value)