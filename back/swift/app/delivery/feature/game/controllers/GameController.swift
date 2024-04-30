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

        switch useCases.initializeGame() {
            case .success(let data):
                return handleResult(data: data, successHandler: self.sResponses.successR)
            case .failure(let error):
                return handleError(error: error, errorHandler: self.sResponses.serverErrR)
            case .notFound:
                return self.sResponses.clientErrR(data: .json(JSONData("Not found")), statusCode: .BAD_REQUEST)
        }

    }

    func restartGame(_ req: Request) -> Response {

        do {

            let gameData = try req.content.decode(GameIDData.self)

            if gameData.gameID.isEmpty {
                return self.sResponses.clientErrR(data: .json(JSONData("Game ID cannot be empty")), statusCode: .BAD_REQUEST)
            }

            switch useCases.resetGame(gameID: gameData.gameID) {
                case .success(let data):
                    return handleResult(data: data, successHandler: self.sResponses.successR)
                case .failure(let error):
                    return handleError(error: error, errorHandler: self.sResponses.serverErrR)
                case .notFound:
                    return self.sResponses.clientErrR(data: .json(JSONData("Not found")), statusCode: .BAD_REQUEST)
            }

        } catch {
            return self.sResponses.clientErrR(data: .json(JSONData("Error decoding request data: \(error.localizedDescription)")), statusCode: .BAD_REQUEST)
        }


    }

    func makeMove(_ req: Request) -> Response  {

        do {

            let gameData = try req.content.decode(GameData.self)

            if gameData.gameID.isEmpty {
                return self.sResponses.clientErrR(data: .json(JSONData("Game ID cannot be empty")), statusCode: .BAD_REQUEST)
            }

//            guard let position = gameData.position else {
//                return self.sResponses.clientErrR(data: .json(JSONData("Position cannot be nil")), statusCode: .BAD_REQUEST)
//            }
//
//            guard let playerSymbol = gameData.playerSymbol else {
//                return self.sResponses.clientErrR(data: .json(JSONData("Player symbol cannot be nil")), statusCode: .BAD_REQUEST)
//            }

            let player = PlayerType(symbol: gameData.playerSymbol)

            switch useCases.makeMove(gameID: gameData.gameID, position: gameData.position, player: player) {
                case .success(let data):
                    return handleResult(data: data, successHandler: self.sResponses.successR)
                case .failure(let error):
                    return handleError(error: error, errorHandler: self.sResponses.serverErrR)
                case .notFound:
                    return self.sResponses.clientErrR(data: .json(JSONData("Not found")), statusCode: .BAD_REQUEST)
            }

        }  catch {
        return self.sResponses.clientErrR(data: .json(JSONData("Error decoding request data: \(error.localizedDescription)")), statusCode: .BAD_REQUEST)
        }

    }

    private func handleResult<T: Encodable>(data: T, successHandler: (_ data: SData, _ statusCode: Status.Success) -> Response) -> Response {
        do {
            let jsonData = try JSONEncoder().encode(data)
            return successHandler(.json(JSONData(jsonData)), .OK)
        } catch {
            let errorMessage = "Error encoding data to JSON: \(error)"
            return self.sResponses.serverErrR(data: .json(JSONData(errorMessage)), statusCode: .INTERNAL_SERVER_ERROR)
        }
    }

    private func handleError(error: Error, errorHandler: (_ data: SData, _ statusCode: Status.ServerError) -> Response) -> Response {
        let errorMessage = "Something went wrong: \(error.localizedDescription)"
        return errorHandler(.json(JSONData(errorMessage)), .INTERNAL_SERVER_ERROR)
    }

}

struct GameIDData: Content, Codable {
    let gameID: String
}

struct GameData: Content, Codable {
    let gameID: String
    let position: CellPosition
    let playerSymbol: CellType
}

