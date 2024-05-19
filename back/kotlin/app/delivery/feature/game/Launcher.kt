package delivery.feature.game

import io.lettuce.core.RedisClient
import io.lettuce.core.api.sync.RedisCommands
import io.lettuce.core.api.async.RedisAsyncCommands
import io.ktor.server.application.*
import io.ktor.server.routing.*

import core.database.redis.RedisData
import core.data.implementation.redis.GameRepositoryImpl
import core.service.game.GameStateChecker
import core.service.game.GameLogic
import core.domain.GameUseCases
import delivery.utils.responses.GameResponses
import delivery.feature.game.controllers.GameController
import delivery.feature.game.endpoints.GameEndpoints


fun launchGameFeature(application: Application, redisData: RedisData){

    val gameRepository = GameRepositoryImpl(redisData)

    val gameChecker = GameStateChecker()
    val gameLogic = GameLogic(gameChecker)

    val gameUseCases = GameUseCases(gameRepository, gameLogic)
    val gameResponses = GameResponses()

    val gameController = GameController(gameUseCases, gameResponses)

    val gameRoutes = GameEndpoints(gameController, application).gameRoutes()

}