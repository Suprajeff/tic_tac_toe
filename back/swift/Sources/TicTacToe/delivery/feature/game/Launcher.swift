import Vapor
import Redis


func launchGameFeature(redisClient: RedisClient, _ app: Application) throws -> GameController {

    let redisData = RedisData(redis: redisClient)
    let gameRepository = GameRepositoryImpl(redisData: redisData)

    let checker = GameStateChecker()
    let gameLogicService = GameLogic(gameStateChecker: checker)

    let gameUseCases = GameUseCases(repo: gameRepository, logic: gameLogicService)
    let gameResponses = GameResponses()

    let gameController = GameController(gameUseCases: gameUseCases, gameResponses: gameResponses)

    return gameController

}

