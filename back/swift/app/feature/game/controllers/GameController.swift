import Foundation

class GameController {
    
    private let useCases: GameUseCasesB
    
    init(gameUseCases: GameUseCasesB){
        self.useCases = gameUseCases
    }
    
    func startGame(_ req: Request) async throws -> Response {

    }

    func restartGame(_ req: Request) async throws -> Response {

    }

    func makeMove(_ req: Request) async throws -> Response {

    }

}

