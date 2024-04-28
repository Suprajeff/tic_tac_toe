import Foundation
import Vapor

class GameEndpoints {
    
    private let controller: GameController
    private let router: RoutesBuilder
    
    init(gameController: GameController, router: RoutesBuilder){
        self.controller = gameController
        self.router = router
        initializeRoutes()
    }
    
    private func initializeRoutes() {
        router.post("start") { req -> Response in
            return self.controller.startGame(req)
        }

        router.post("restart") { req -> Response in
            return self.controller.restartGame(req)
        }

        router.post("move") { req -> Response in
            return self.controller.makeMove(req)
        }
    }
    
}