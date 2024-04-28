import Foundation
import Vapor

class GameController {
    
    private let useCases: GameUseCasesB
    
    init(gameUseCases: GameUseCasesB){
        self.useCases = gameUseCases
    }
    
    func startGame(_ req: Request) -> Response {

    }

    func restartGame(_ req: Request) -> Response {

    }

    func makeMove(_ req: Request) -> Response {

    }

}

