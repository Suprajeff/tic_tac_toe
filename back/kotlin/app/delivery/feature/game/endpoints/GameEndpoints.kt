package delivery.feature.game.endpoints

import io.ktor.server.*
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.plugins.cors.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import kotlinx.coroutines.*

class GameEndpoints(private val controller: GameController, private val application: Application) {
    
    fun gameRoutes() {

        application.routing {

            options {
//                call.respondPreflight()
            }

            get("/hello") {
                call.respondText("Hello Kotlin!")
            }

            get("/start") {
                val call = call
                val job = launch {
                    controller.startGame(call)
                }
                job.join()
            }

            get("/restart") {
                val call = call
                val job = launch {
                    controller.restartGame(call)
                }
                job.join()
            }

            post("/move") {
                val call = call
                val job = launch {
                    controller.makeMove(call)
                }
                job.join()
            }

        }

    }
    
}