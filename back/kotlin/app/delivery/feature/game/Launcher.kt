package delivery.feature.game

import io.lettuce.core.RedisClient
import io.lettuce.core.api.sync.RedisCommands
import io.lettuce.core.api.async.RedisAsyncCommands
import io.ktor.server.application.*
import io.ktor.server.routing.*

fun launchGameFeature(application: Application, redisData: RedisData, ){

    val gameRepository = GameRepositoryImpl(redisData)

    val gameChecker = GameStateChecker()
    val gameLogic = GameLogic(gameChecker)

    val gameUseCases = GameUseCases(gameRepository, gameLogic)
    val gameResponses = GameResponses()

    val gameController = GameController(gameUseCases, gameResponses)

    val gameRoutes = GameEndpoints(gameController, application).gameRoutes()

}