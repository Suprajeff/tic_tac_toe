package delivery.feature.game.controllers

import io.ktor.server.*
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.sessions.*
import io.ktor.server.routing.*
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import kotlinx.serialization.encodeToString
import kotlinx.serialization.decodeFromString
import kotlinx.serialization.json.Json
import kotlinx.serialization.*
import io.ktor.server.request.*
import io.ktor.server.request.receiveText
import io.ktor.server.request.receiveParameters
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
        private val gameHTMLContent = GameHTMLContent()
    }

    suspend fun startGame(call: ApplicationCall) {

            logger.info("Starting Game")

            val result = withContext(scope.coroutineContext) {
                useCases.initializeGame()
            }

            logger.info("Game initialization result: $result")

            if (result is Result.Success<GameType>) {
                val boardHtml = gameHTMLContent.getNewBoard()
                withContext(scope.coroutineContext) {
                    saveResult(call, result.data)
                    logger.info("Result Saved")
                    responses.successR(call = call, data = SData.Html(boardHtml), statusCode = Status.Success.OK)
                }
            } else {
                withContext(scope.coroutineContext) {
                    handleResult(result, call)
                }
            }

    }

    suspend fun restartGame(call: ApplicationCall) {

        logger.info("Restarting Game")
        val savedResult = call.sessions.get<GameSession>()
        val gameID = savedResult?.gameID
        if (gameID == null) {
            responses.serverErrR(call = call, data = SData.Json(emptyMap()), statusCode = Status.ServerError.INTERNAL_SERVER_ERROR)
            return
        }
        val result = withContext(scope.coroutineContext) {
            useCases.resetGame(gameID)
        }
        logger.info("Game restart result: $result")
        if (result is Result.Success<GameType>) {
            withContext(scope.coroutineContext) {
                saveResult(call, result.data)
                val boardHtml = gameHTMLContent.getNewBoard()
                responses.successR(call = call, data = SData.Html(boardHtml), statusCode = Status.Success.OK)
            }
        } else {
            withContext(scope.coroutineContext) {
                handleResult(result, call)
            }
        }

    }

    suspend fun makeMove(call: ApplicationCall) {

            logger.info("Making Move")
            val positionData = call.receiveParameters()["position"]

            val savedResult = call.sessions.get<GameSession>()
            val gameID = savedResult?.gameID
            val currentPlayer = savedResult?.currentPlayer

            if (gameID == null || currentPlayer == null || positionData == null) {
                responses.serverErrR(call = call, data = SData.Json(emptyMap()), statusCode = Status.ServerError.INTERNAL_SERVER_ERROR)
                return
            }

            val position = CellPosition.valueOf(positionData)

            val result = withContext(scope.coroutineContext) {
                useCases.makeMove(gameID, position, currentPlayer)
            }

            logger.info("Game Move result: $result")

            if (result is Result.Success<GameType>) {

                val newTitle = when {
                    result.data.gameState == GameState.WON && result.data.winner != null -> {
                        if (result.data.winner.symbol == CellType.X) GameTitle.PLAYER_X_WON else GameTitle.PLAYER_O_WON
                    }
                    result.data.gameState == GameState.DRAW -> GameTitle.DRAW
                    else -> GameTitle.PLAYING
                }

                when (result.data.state) {
                    is State.BoardState -> {
                        logger.info("Board state is an array or a dictionary")
                        responses.serverErrR(call = call, data = SData.Json(emptyMap()), statusCode = Status.ServerError.INTERNAL_SERVER_ERROR)
                        return
                    }
                    is State.MovesState -> {
                        withContext(scope.coroutineContext) {
                            saveResult(call, result.data)
                            val newMove = gameHTMLContent.getBoard(newTitle, result.data.state.moves)
                            responses.successR(call = call, data = SData.Html(newMove), statusCode = Status.Success.OK)
                        }
                    }
                }

            } else {
                withContext(scope.coroutineContext) {
                    handleResult(result, call)
                }
            }

    }

    private suspend fun handleResult(result: Result<GameType>, call: ApplicationCall) {
        when {
//            result is Result.Success<GameType> -> responses.successR(
//                call = call,
//                data = SData.Json(mapOf("data" to result.data)),
//                statusCode = Status.Success.OK
//            )
            result is Result.Error -> responses.serverErrR(
                call = call,
                data = SData.Json(emptyMap()),
                statusCode = Status.ServerError.INTERNAL_SERVER_ERROR
            )
            result is Result.NotFound -> responses.clientErrR(
                call = call,
                data = SData.Json(emptyMap()),
                statusCode = Status.ClientError.REQUEST_TIMEOUT
            )
        }
    }

    private suspend fun saveResult(call: ApplicationCall, result: GameType) {

        val serializedState = Json.encodeToString(result.state)

        call.sessions.set(GameSession(
            gameID = result.id,
            currentPlayer = result.currentPlayer,
            gameState = result.gameState,
            state = serializedState,
            winner = result.winner
        ))
    }

}