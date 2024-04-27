import Foundation
import Vapor
import App

class GameEndpoints {
    
    private let controller: GameController
    private let router: Router
    
    init(gameController: GameController, router: Router){
        self.controller = gameController
        self.router = router
        initializeRoutes()
    }
    
    private func initializeRoutes() {
        router.post("start") { req -> EventLoopFuture<Response> in
            return self.controller.startGame(req)
        }

        router.post("restart") { req -> EventLoopFuture<Response> in
            return self.controller.restartGame(req)
        }

        router.post("move") { req -> EventLoopFuture<Response> in
            return self.controller.makeMove(req)
        }
    }
    
}