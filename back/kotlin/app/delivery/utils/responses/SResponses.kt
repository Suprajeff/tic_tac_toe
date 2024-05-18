package delivery.utils.responses

import io.ktor.http.HttpStatusCode
import io.ktor.http.ContentType
import io.ktor.server.response.respondText
import io.ktor.server.application.*
import io.ktor.http.*
import io.ktor.server.*
import io.ktor.websocket.*
import org.slf4j.Logger;
import org.slf4j.LoggerFactory

class GameResponses() {
    
    companion object {
        private val logger = LoggerFactory.getLogger(GameResponses::class.java)
    }

    private suspend fun sendHTTPResponse(call: ApplicationCall, data: SData, statusCode: HttpStatusCode) {
        when (data) {
            is SData.Json -> {
                logger.info("JSON!")
                call.respondText(data.data.toString(), contentType = ContentType.Application.Json, status = statusCode)
            }
            is SData.Html -> {
                logger.info("HTML!")
                call.respondText(data.data, contentType = ContentType.Text.Html, status = statusCode)
            }
        }
    }

    private suspend fun sendSocketResponse(socket: WebSocketSession, data: SData, room: String? = null) {
        when (data) {
            is SData.Json -> {
                if (room != null) {
                    // need to implement logic to send to all connected users
//                            res.session.broadcast(data.data.toString(), room)
                } else {
                    socket.send(Frame.Text(data.data.toString()))
                }
            }
            is SData.Html -> {
                if (room != null) {
                // need to implement logic to send to all connected users
                    //res.session.broadcast(data.data, room)
                } else {
                    socket.send(Frame.Text(data.data.toString()))
                }
            }
        }
    }

    suspend fun informationR(call: ApplicationCall, data: SData, statusCode: Status.Informational) {
        sendHTTPResponse(call, data, statusCode.toHttpStatusCode())
    }

    suspend fun successR(call: ApplicationCall, data: SData, statusCode: Status.Success) {
        sendHTTPResponse(call, data, statusCode.toHttpStatusCode())
    }

    suspend fun redirectionR(call: ApplicationCall, data: SData, statusCode: Status.Redirection) {
        sendHTTPResponse(call, data, statusCode.toHttpStatusCode())
    }

    suspend fun clientErrR(call: ApplicationCall, data: SData, statusCode: Status.ClientError) {
        sendHTTPResponse(call, data, statusCode.toHttpStatusCode())
    }

    suspend fun serverErrR(call: ApplicationCall, data: SData, statusCode: Status.ServerError) {
        sendHTTPResponse(call, data, statusCode.toHttpStatusCode())
    }

    suspend fun socketR(socket: WebSocketSession, data: SData, room: String? = null) {
        sendSocketResponse(socket, data, room)
    }

}

fun Status.Informational.toHttpStatusCode(): HttpStatusCode = HttpStatusCode.fromValue(this.value)
fun Status.Success.toHttpStatusCode(): HttpStatusCode = HttpStatusCode.fromValue(this.value)
fun Status.Redirection.toHttpStatusCode(): HttpStatusCode = HttpStatusCode.fromValue(this.value)
fun Status.ClientError.toHttpStatusCode(): HttpStatusCode = HttpStatusCode.fromValue(this.value)
fun Status.ServerError.toHttpStatusCode(): HttpStatusCode = HttpStatusCode.fromValue(this.value)