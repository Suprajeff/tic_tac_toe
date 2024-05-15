import io.ktor.server.*
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.routing.*
import kotlinx.serialization.Serializable
import kotlinx.serialization.decodeFromString
import kotlinx.serialization.json.Json
import io.ktor.server.request.receiveText

class GameController(private val useCases: GameUseCasesB, private val responses: GameResponses) {
    
    suspend fun startGame(call: ApplicationCall) {
        
        val result = useCases.initializeGame()
        handleResult(result, call)

    }

    suspend fun restartGame(call: ApplicationCall) {

        val requestBody = call.receiveText()
        val parsedData = Json.decodeFromString<GameIDData>(requestBody)

        val gameID = parsedData.gameID

        val result = useCases.resetGame(gameID)
        handleResult(result, call)

    }

    suspend fun makeMove(call: ApplicationCall) {
        
        val requestBody = call.receiveText()
        val parsedData = Json.decodeFromString<GameData>(requestBody)

        val gameID = parsedData.gameID
        val position = parsedData.position
        val player = PlayerType(symbol = parsedData.playerSymbol)

        val result = useCases.makeMove(gameID, position, player)
        handleResult(result, call)

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