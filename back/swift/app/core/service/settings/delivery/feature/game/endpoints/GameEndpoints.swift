import Foundation
import Vapor

class GameEndpoints: RouteCollection {
    
    let controller: GameController
    
    init(gameController: GameController) {
        self.controller = gameController
    }

    func boot(routes: RoutesBuilder) throws {
        let gameRoutes = routes.grouped("game")
        gameRoutes.get("hello", use: helloWorld)
        gameRoutes.post("start", use: startGame)
        gameRoutes.post("restart", use: restartGame)
        gameRoutes.post("move", use: makeMove)
    }

    func helloWorld(req: Request) throws -> String {
        return "Hello, World!"
    }

    func startGame(req: Request) throws -> EventLoopFuture<Response> {
        return try controller.startGame(req)
    }

    func restartGame(req: Request) throws -> EventLoopFuture<Response> {
        return try controller.restartGame(req)
    }

    func makeMove(req: Request) throws -> EventLoopFuture<Response> {
        return try controller.makeMove(req)
    }

//    router.post("start") { req -> Response in
//        return self.controller.startGame(req)
//    }
//
//    router.post("restart") { req -> Response in
//        return self.controller.restartGame(req)
//    }
//
//    router.post("move") { req -> Response in
//        return self.controller.makeMove(req)
//    }

    
}