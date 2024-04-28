import io.ktor.http.HttpStatusCode
import io.ktor.http.ContentType
import io.ktor.response.respondText



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
                            res.session.broadcast(data.data.toString(), room)
                        } else {
                            res.session.send(data.data.toString())
                        }
                    }
                    is SData.Html -> {
                        if (room != null) {
                            res.session.broadcast(data.data, room)
                        } else {
                            res.session.send(data.data)
                        }
                    }
                }
            }
        }
    }

    suspend fun informationR(res: SChannel, data: SData, statusCode: Status.Informational? = null, room: String? = null) {
        sendResponse(res, data, statusCode, room)
    }

    suspend fun successR(res: SChannel, data: SData, statusCode: Status.Success? = null, room: String? = null) {
        sendResponse(res, data, statusCode, room)
    }

    suspend fun redirectionR(res: SChannel, data: SData, statusCode: Status.Redirection? = null, room: String? = null) {
        sendResponse(res, data, statusCode, room)
    }

    suspend fun clientErrR(res: SChannel, data: SData, statusCode: Status.ClientError? = null, room: String? = null) {
        sendResponse(res, data, statusCode, room)
    }

    suspend fun serverErrR(res: SChannel, data: SData, statusCode: Status.ServerError? = null, room: String? = null) {
        sendResponse(res, data, statusCode, room)
    }
}