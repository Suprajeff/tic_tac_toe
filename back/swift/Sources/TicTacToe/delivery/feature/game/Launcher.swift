import Foundation
import Vapor
import Redis


public func launchGameFeature(redisClient: RedisClient, _ app: Application) throws {

    let redisData = RedisData(redis: redisClient)
    let gameRepository = GameRepositoryImpl(redisData: redisData)

    let checker = GameStateChecker()
    let gameLogicService = GameLogic(gameStateChecker: checker)

    let gameUseCases = GameUseCases(repo: gameRepository, logic: gameLogicService)
    let gameResponses = GameResponses()

    let gameController = GameController(gameUseCases: gameUseCases, gameResponses: gameResponses)

    do{
        print("Registering routes...")
        try app.register(collection: GameEndpoints(gameController: gameController))
    } catch {
        print(error)
    }

}

