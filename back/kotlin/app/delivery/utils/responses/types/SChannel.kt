package delivery.utils.responses.types

import io.ktor.server.application.*
import io.ktor.http.*
import io.ktor.server.*
import io.ktor.websocket.*

sealed class SChannel {
    data class HttpResponse(val call: ApplicationCall) : SChannel()
    data class WebSocket(val session: WebSocketSession) : SChannel()
}