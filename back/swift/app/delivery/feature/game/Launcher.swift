import Foundation
import Vapor


func launchGameFeature(_ app: Application) throws {

    try redisSetup(app)

    let redisClient = app.redis

    let redisData = RedisData(redis: redisClient)
    let gameRepository = GameRepositoryImpl(redisData: redisData)

    let checker = GameStateChecker()
    let gameLogicService = GameLogic(gameStateChecker: checker)

    let gameUseCases = GameUseCases(repo: gameRepository, logic: gameLogicService)
    let gameResponses = GameResponses()

    let gameController = GameController(gameUseCases: gameUseCases, gameResponses: gameResponses)

    let gameEndpoints = GameEndpoints(gameController: gameController)

    do{
        try app.register(collection: gameEndpoints)
    } catch {
        print(error)
    }

}

