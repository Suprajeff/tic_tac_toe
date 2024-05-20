import Foundation
import Vapor

class GameController {
    
    private let useCases: GameUseCasesB
    private let sResponses: GameResponses
    
    init(gameUseCases: GameUseCasesB, gameResponses: GameResponses){
        self.useCases = gameUseCases
        self.sResponses = gameResponses
    }
    
    func startGame(_ req: Request) async throws -> Response {

        switch await useCases.initializeGame() {
            case .success(let data):
                print(data)
                let boardHtml = GameHTMLContent.getNewBoard()
                return try handleResult(req: req, data: boardHtml, successHandler: self.sResponses.successR)
            case .failure(let error):
                return try handleError(req: req, error: error, errorHandler: self.sResponses.serverErrR)
            case .notFound:
                return try handleNotFound(req: req, message: "Not found", notFoundHandler: self.sResponses.clientErrR)
        }

    }

    func restartGame(_ req: Request) async throws -> Response {

        do {

            let gameData = try req.content.decode(GameIDData.self)

            if gameData.gameID.isEmpty {
                return try handleNotFound(req: req, message: "Game ID cannot be empty", notFoundHandler: self.sResponses.clientErrR)
            }

            switch await useCases.resetGame(gameID: gameData.gameID) {
                case .success(let data):
                    print(data)
                    let boardHtml = GameHTMLContent.getNewBoard()
                    return try handleResult(req: req, data: boardHtml, successHandler: self.sResponses.successR)
                case .failure(let error):
                    return try handleError(req: req, error: error, errorHandler: self.sResponses.serverErrR)
                case .notFound:
                    return try handleNotFound(req: req, message: "Not found", notFoundHandler: self.sResponses.clientErrR)
            }

        } catch {
            return try handleError(req: req, error: error, errorHandler: self.sResponses.serverErrR)
        }


    }

    func makeMove(_ req: Request) async throws -> Response  {

        do {

            let gameData = try req.content.decode(GameData.self)

            if gameData.gameID.isEmpty {
                return try handleNotFound(req: req, message: "Game ID cannot be empty", notFoundHandler: self.sResponses.clientErrR)
            }

            let player = PlayerType(symbol: gameData.playerSymbol)

            switch await useCases.makeMove(gameID: gameData.gameID, position: gameData.position, player: player) {
                case .success(let data):
                    print(data)
                    return try handleResult(req: req, data: data, successHandler: self.sResponses.successR)
                case .failure(let error):
                    return try handleError(req: req, error: error, errorHandler: self.sResponses.serverErrR)
                case .notFound:
                    return try handleNotFound(req: req, message: "Not found", notFoundHandler: self.sResponses.clientErrR)
            }

        }  catch {
            return try handleError(req: req, error: error, errorHandler: self.sResponses.serverErrR)
        }

    }

    private func handleResult<T: Encodable>(req: Request, data: T, successHandler: (_ req: Request, _ data: SData, _ statusCode: Status.Success) -> Response) throws -> Response {
        do {
            let jsonData = try JSONEncoder().encode(data)
            return try successHandler(req, .json(JSONData(jsonData)), .OK)
        } catch {
            let errorMessage = "Error encoding data to JSON: \(error)"
            return try self.sResponses.serverErrR(req: req, data: .json(JSONData(errorMessage)), statusCode: .INTERNAL_SERVER_ERROR)
        }
    }

    private func handleError(req: Request, error: Error, errorHandler: (_ req: Request, _ data: SData, _ statusCode: Status.ServerError) -> Response) throws -> Response {
        let errorMessage = "Something went wrong: \(error.localizedDescription)"
        return try errorHandler(req, .json(JSONData(errorMessage)), .INTERNAL_SERVER_ERROR)
    }

    private func handleNotFound(req: Request, message: String, notFoundHandler: (_ req: Request, _ data: SData, _ statusCode: Status.ClientError) -> Response) throws -> Response {
        return try notFoundHandler(req, .json(JSONData(message)), .BAD_REQUEST)
    }

}

