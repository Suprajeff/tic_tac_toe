import io.ktor.server.*
import io.ktor.http.*
import io.ktor.application.*
import io.ktor.routing.*
import kotlinx.coroutines.*

class GameEndpoints(private val controller: GameController) {
    
    fun Application.gameRoutes() {

        routing {

            post("/start") {
                val call = call
                launch {
                    controller.startGame(call)
                }
            }

            post("/restart") {
                val call = call
                launch {
                    controller.restartGame(call)
                }
            }

            post("/move") {
                val call = call
                launch {
                    controller.makeMove(call)
                }
            }

        }

    }
    
}