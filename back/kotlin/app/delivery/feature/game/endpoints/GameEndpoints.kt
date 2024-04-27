import io.ktor.server.application.*
import io.ktor.server.routing.*

class GameEndpoints(private val controller: GameController){
    
    fun Route(routing: Routing) {
        routing.post("/start") {
            controller.startGame(call)
        }
        routing.post("/restart") {
            controller.restartGame(call)
        }
        routing.post("/move") {
            controller.makeMove(call)
        }
    }
    
}