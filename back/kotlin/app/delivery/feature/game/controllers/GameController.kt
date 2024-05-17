import io.ktor.server.*
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.routing.*
import kotlinx.serialization.Serializable
import kotlinx.serialization.decodeFromString
import kotlinx.serialization.json.Json
import io.ktor.server.request.receiveText
import org.slf4j.Logger;
import org.slf4j.LoggerFactory
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.withContext
import kotlinx.coroutines.launch

class GameController(private val useCases: GameUseCasesB, private val responses: GameResponses) {
    
    companion object {
        private val logger = LoggerFactory.getLogger(GameController::class.java)
        private val scope = CoroutineScopesModule.providesCoroutineScope(DispatchersProvider.provideIODispatcher())
    }

    suspend fun startGame(call: ApplicationCall) {

        scope.launch {
            logger.info("Starting Game")
            val result = useCases.initializeGame()
            logger.info("Game initialization result: $result")
            handleResult(result, call)
        }

    }

    suspend fun restartGame(call: ApplicationCall) {

        scope.launch {
            logger.info("Restarting Game")
            val gameID = ""
            val result = useCases.resetGame(gameID)
            logger.info("Game restart result: $result")
            handleResult(result, call)
        }

    }

    suspend fun makeMove(call: ApplicationCall) {
        
        scope.launch {
            logger.info("Making Move")
            val requestBody = call.receiveText()
            val parsedData = Json.decodeFromString<GameData>(requestBody)
            val gameID = parsedData.gameID
            val position = parsedData.position
            val player = PlayerType(symbol = parsedData.playerSymbol)
            val result = useCases.makeMove(gameID, position, player)
            logger.info("Game Move result: $result")
            handleResult(result, call)
        }

    }

    private suspend fun handleResult(result: Result<GameType>, call: ApplicationCall) {
        when {
            result is Result.Success<GameType> -> responses.successR(
                res = SChannel.HttpResponse(call),
                data = SData.Json(mapOf("data" to result.data)),
                statusCode = Status.Success.OK
            )
            result is Result.Error -> responses.serverErrR(
                res = SChannel.HttpResponse(call),
                data = SData.Json(emptyMap()),
                statusCode = Status.ServerError.INTERNAL_SERVER_ERROR
            )
            result is Result.NotFound -> responses.clientErrR(
                res = SChannel.HttpResponse(call),
                data = SData.Json(emptyMap()),
                statusCode = Status.ClientError.NOT_FOUND
            )
        }
    }

}