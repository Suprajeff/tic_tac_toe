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
        gameRoutes.get("start", use: startGame)
        gameRoutes.get("restart", use: restartGame)
        gameRoutes.post("move", use: makeMove)
    }

    func helloWorld(req: Request) throws -> Response {
        print("Hello requested")
        let helloString = "Hello, Swift!"
        let helloData = helloString.data(using: .utf8) ?? Data()
        return Response(status: .ok, body: .init(data: helloData))
    }

    func startGame(req: Request) throws -> EventLoopFuture<Response> {
        return controller.startGame(req)
    }

    func restartGame(req: Request) throws -> EventLoopFuture<Response> {
        return controller.restartGame(req)
    }

    func makeMove(req: Request) throws -> EventLoopFuture<Response> {
        return controller.makeMove(req)
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