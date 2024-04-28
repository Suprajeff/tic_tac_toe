import io.ktor.server.*
import io.ktor.http.*
import io.ktor.application.*
import io.ktor.routing.*

class GameController(private val useCases: GameUseCasesB, private val responses: GameResponses) {
    
    suspend fun startGame(call: ApplicationCall) {
        
        val result = useCases.initializeGame()

        when (result.status) {
            GameStatus.SUCCESS -> responses.successR(
                res = SChannel.HttpResponse(call),
                data = SData.Json(mapOf("data" to result.data)),
                statusCode = Status.Success.OK
            )
            GameStatus.ERROR -> responses.serverErrR(
                res = SChannel.HttpResponse(call),
                data = SData.Json(emptyMap()),
                statusCode = Status.ServerError.INTERNAL_SERVER_ERROR
            )
            GameStatus.NOT_FOUND -> responses.clientErrR(
                res = SChannel.HttpResponse(call),
                data = SData.Json(emptyMap()),
                statusCode = Status.ClientError.NOT_FOUND
            )
        }

    }

    suspend fun restartGame(call: ApplicationCall) {

        val gameID = call.parameters["gameID"] ?: return@restartGame

        val result = useCases.resetGame(gameID)
        when (result.status) {
            GameStatus.SUCCESS -> responses.successR(
                res = SChannel.HttpResponse(call),
                data = SData.Json(mapOf("data" to result.data)),
                statusCode = Status.Success.OK
            )
            GameStatus.ERROR -> responses.serverErrR(
                res = SChannel.HttpResponse(call),
                data = SData.Json(emptyMap()),
                statusCode = Status.ServerError.INTERNAL_SERVER_ERROR
            )
            GameStatus.NOT_FOUND -> responses.clientErrR(
                res = SChannel.HttpResponse(call),
                data = SData.Json(emptyMap()),
                statusCode = Status.ClientError.NOT_FOUND
            )
        }

    }

    suspend fun makeMove(call: ApplicationCall) {
        
        val gameID = call.parameters["gameID"] ?: return@makeMove
        val positionData = call.parameters["positionData"] ?: return@makeMove
        val playerData = call.parameters["playerData"] ?: return@makeMove

        val position = positionData.parseAs<CellPosition>() ?: return@makeMove
        val player = playerData.parseAs<PlayerType>() ?: return@makeMove

        val result = useCases.makeMove(gameID, position, player)
        when (result.status) {
            GameStatus.SUCCESS -> responses.successR(
                res = SChannel.HttpResponse(call),
                data = SData.Json(mapOf("data" to result.data)),
                statusCode = Status.Success.OK
            )
            GameStatus.ERROR -> responses.serverErrR(
                res = SChannel.HttpResponse(call),
                data = SData.Json(emptyMap()),
                statusCode = Status.ServerError.INTERNAL_SERVER_ERROR
            )
            GameStatus.NOT_FOUND -> responses.clientErrR(
                res = SChannel.HttpResponse(call),
                data = SData.Json(emptyMap()),
                statusCode = Status.ClientError.NOT_FOUND
            )
        }

    }
    
} 