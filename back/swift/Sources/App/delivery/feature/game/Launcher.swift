import Vapor
import Redis


func launchGameFeature(_ app: Application) async throws {

    let redisData = RedisData(redis: app.redis)
    let gameRepository = GameRepositoryImpl(redisData: redisData)

    let checker = GameStateChecker()
    let gameLogicService = GameLogic(gameStateChecker: checker)

    let gameUseCases = GameUseCases(repo: gameRepository, logic: gameLogicService)
    let gameResponses = GameResponses()

    let gameController = GameController(gameUseCases: gameUseCases, gameResponses: gameResponses)

    let gameEndpoints = GameEndpoints(gameController: gameController)

    try app.routes.register(collection: gameEndpoints)

}

