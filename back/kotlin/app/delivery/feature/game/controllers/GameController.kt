import io.ktor.server.*
import io.ktor.http.*
import io.ktor.application.*
import io.ktor.routing.*

class GameController(private val useCases: GameUseCasesB, private val responses: GameResponses) {
    
    suspend fun startGame(call: ApplicationCall) {
        
    }

    suspend fun restartGame(call: ApplicationCall) {

    }

    suspend fun makeMove(call: ApplicationCall) {
        
    }
    
} 