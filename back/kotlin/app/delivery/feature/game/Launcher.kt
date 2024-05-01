import io.lettuce.core.RedisClient
import io.lettuce.core.api.sync.RedisCommands
import io.lettuce.core.api.async.RedisAsyncCommands

fun lauchGameFeature(){

    val redisClient: RedisCommands<String, String>? = try {
        createRedisClient()
    } catch (e: Exception) {
        println("Error creating Redis client: ${e.message}")
        return
    }

    redisClient?.let {

        val redisData = RedisData(it)

        val gameRepository = GameRepositoryImpl(redisData)

        val gameChecker = GameStateChecker()
        val gameLogic = GameLogic(gameChecker)

        val gameUseCases = GameUseCases(gameRepository, gameLogic)
        val gameResponses = GameResponses()

        val gameController = GameController(gameUseCases, gameResponses)

        val gameRoutes = GameEndpoints(gameController)

    }


}