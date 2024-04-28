import io.ktor.application.*
import io.ktor.http.*
import io.ktor.server.*

sealed class SChannel {
    data class HttpResponse(val call: ApplicationCall) : SChannel()
    data class WebSocket(val session: WebSocketServerSession) : SChannel()
}