import io.ktor.http.HttpStatusCode
import io.ktor.http.ContentType
import io.ktor.response.respondText
import io.ktor.websocket.*
import io.ktor.application.*
import io.ktor.http.*
import io.ktor.server.*
import io.ktor.websocket.*
import io.ktor.http.cio.websocket.*

class GameResponses() {
    
    private suspend fun sendResponse(res: SChannel, data: SData, statusCode: HttpStatusCode? = null, room: String? = null) {
        when (res) {
            is SChannel.HttpResponse -> {
                when (data) {
                    is SData.Json -> {
                        if (statusCode != null) {
                            res.call.respondText(data.data.toString(), contentType = ContentType.Application.Json, status = statusCode)
                        } else {
                            res.call.respondText(data.data.toString(), ContentType.Application.Json)
                        }
                    }
                    is SData.Html -> {
                        if (statusCode != null) {
                            res.call.respondText(data.data, contentType = ContentType.Text.Html, status = statusCode)
                        } else {
                            res.call.respondText(data.data, ContentType.Text.Html)
                        }
                    }
                }
            }
            is SChannel.WebSocket -> {
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
        }
    }

    suspend fun informationR(res: SChannel, data: SData, statusCode: Status.Informational? = null, room: String? = null) {
        sendResponse(res, data, statusCode?.toHttpStatusCode(), room)
    }

    suspend fun successR(res: SChannel, data: SData, statusCode: Status.Success? = null, room: String? = null) {
        sendResponse(res, data, statusCode?.toHttpStatusCode(), room)
    }

    suspend fun redirectionR(res: SChannel, data: SData, statusCode: Status.Redirection? = null, room: String? = null) {
        sendResponse(res, data, statusCode?.toHttpStatusCode(), room)
    }

    suspend fun clientErrR(res: SChannel, data: SData, statusCode: Status.ClientError? = null, room: String? = null) {
        sendResponse(res, data, statusCode?.toHttpStatusCode(), room)
    }

    suspend fun serverErrR(res: SChannel, data: SData, statusCode: Status.ServerError? = null, room: String? = null) {
        sendResponse(res, data, statusCode?.toHttpStatusCode(), room)
    }
}

fun Status.Informational.toHttpStatusCode(): HttpStatusCode = HttpStatusCode.fromValue(this.value)
fun Status.Success.toHttpStatusCode(): HttpStatusCode = HttpStatusCode.fromValue(this.value)
fun Status.Redirection.toHttpStatusCode(): HttpStatusCode = HttpStatusCode.fromValue(this.value)
fun Status.ClientError.toHttpStatusCode(): HttpStatusCode = HttpStatusCode.fromValue(this.value)
fun Status.ServerError.toHttpStatusCode(): HttpStatusCode = HttpStatusCode.fromValue(this.value)