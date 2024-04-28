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

        return useCases.initializeGame().flatMap { result in
            switch result.status {
            case .success:
                return self.sResponses.successR(res: .httpResponse(req.response), data: .json(JSONData(result.data)), statusCode: .OK)
            case .error:
                return self.sResponses.serverErrR(res: .httpResponse(req.response), data: .json(JSONData(Data())), statusCode: .INTERNAL_SERVER_ERROR)
            case .notFound:
                return self.sResponses.clientErrR(res: .httpResponse(req.response), data: .json(JSONData(Data())), statusCode: .BAD_REQUEST)
            }
        }

    }

    func restartGame(_ req: Request) -> Response {

        guard let gameID = req.data["gameID"]?.string else {
                return req.eventLoop.makeFailedFuture(Abort(.badRequest))
        }

        return useCases.resetGame(gameID).flatMap { result in
            switch result.status {
            case .success:
                return self.sResponses.successR(res: .httpResponse(req.response), data: .json(JSONData(result.data)), statusCode: .OK)
            case .error:
                return self.sResponses.serverErrR(res: .httpResponse(req.response), data: .json(JSONData(Data())), statusCode: .INTERNAL_SERVER_ERROR)
            case .notFound:
                return self.sResponses.clientErrR(res: .httpResponse(req.response), data: .json(JSONData(Data())), statusCode: .BAD_REQUEST)
            }
        }


    }

    func makeMove(_ req: Request) -> Response {

        guard let gameID = req.data["gameID"]?.string,
                    let positionData = req.data["positionData"]?.string,
                    let playerData = req.data["playerData"]?.string,
                    let position = try? JSONDecoder().decode(CellPosition.self, from: Data(positionData.utf8)),
                    let player = try? JSONDecoder().decode(PlayerType.self, from: Data(playerData.utf8)) else {
                return req.eventLoop.makeFailedFuture(Abort(.badRequest))
        }

        return useCases.makeMove(gameID, position, player).flatMap { result in
            switch result.status {
            case .success:
                return self.sResponses.successR(res: .httpResponse(req.response), data: .json(JSONData(result.data)), statusCode: .OK)
            case .error:
                return self.sResponses.serverErrR(res: .httpResponse(req.response), data: .json(JSONData(Data())), statusCode: .INTERNAL_SERVER_ERROR)
            case .notFound:
                return self.sResponses.clientErrR(res: .httpResponse(req.response), data: .json(JSONData(Data())), statusCode: .BAD_REQUEST)
            }
        }

    }

}

