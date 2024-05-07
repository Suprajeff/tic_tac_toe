import io.ktor.server.*
import io.ktor.http.*
import io.ktor.application.*
import io.ktor.response.*
import io.ktor.routing.*
import kotlinx.coroutines.*

class GameEndpoints(private val controller: GameController, private val application: Application) {
    
    fun gameRoutes() {

        application.routing {

            get("/hello") {
                call.respondText("Hello Kotlin!")
            }

            get("/start") {
                val call = call
                launch {
                    controller.startGame(call)
                }
            }

            get("/restart") {
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