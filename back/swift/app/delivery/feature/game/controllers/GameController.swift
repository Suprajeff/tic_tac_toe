import Foundation
import Vapor

class GameController {
    
    private let useCases: GameUseCasesB
    private let sResponses: GameResponses
    
    init(gameUseCases: GameUseCasesB, gameResponses: GameResponses){
        self.useCases = gameUseCases
        self.sResponses = gameResponses
    }
    
    func startGame(_ req: Request) -> Response {

    }

    func restartGame(_ req: Request) -> Response {

    }

    func makeMove(_ req: Request) -> Response {

    }

}

