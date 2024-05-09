import Foundation
import Vapor

class GameController {
    
    private let useCases: GameUseCasesB
    private let sResponses: GameResponses
    
    init(gameUseCases: GameUseCasesB, gameResponses: GameResponses){
        self.useCases = gameUseCases
        self.sResponses = gameResponses
    }
    
    func startGame(_ req: Request) -> EventLoopFuture<Response> {

        switch useCases.initializeGame() {
            case .success(let data):
                let boardHtml = GameHTMLContent.getNewBoard()
                //return handleResult(data: data, successHandler: self.sResponses.successR)
            case .failure(let error):
                return handleError(error: error, errorHandler: self.sResponses.serverErrR)
            case .notFound:
                return handleNotFound(message: "Not found", notFoundHandler: self.sResponses.clientErrR)
        }

    }

    func restartGame(_ req: Request) -> EventLoopFuture<Response> {

        do {

            let gameData = try req.content.decode(GameIDData.self)

            if gameData.gameID.isEmpty {
                return handleNotFound(message: "Game ID cannot be empty", notFoundHandler: self.sResponses.clientErrR)
            }

            switch useCases.resetGame(gameID: gameData.gameID) {
                case .success(let data):
                    let boardHtml = GameHTMLContent.getNewBoard()
                    //return handleResult(data: data, successHandler: self.sResponses.successR)
                case .failure(let error):
                    return handleError(error: error, errorHandler: self.sResponses.serverErrR)
                case .notFound:
                    return handleNotFound(message: "Not found", notFoundHandler: self.sResponses.clientErrR)
            }

        } catch {
            return handleError(error: error, errorHandler: self.sResponses.serverErrR)
        }


    }

    func makeMove(_ req: Request) -> EventLoopFuture<Response>  {

        do {

            let gameData = try req.content.decode(GameData.self)

            if gameData.gameID.isEmpty {
                return handleNotFound(message: "Game ID cannot be empty", notFoundHandler: self.sResponses.clientErrR)
            }

            let player = PlayerType(symbol: gameData.playerSymbol)

            switch useCases.makeMove(gameID: gameData.gameID, position: gameData.position, player: player) {
                case .success(let data):
                    return handleResult(data: data, successHandler: self.sResponses.successR)
                case .failure(let error):
                    return handleError(error: error, errorHandler: self.sResponses.serverErrR)
                case .notFound:
                    return handleNotFound(message: "Not found", notFoundHandler: self.sResponses.clientErrR)
            }

        }  catch {
            return handleError(error: error, errorHandler: self.sResponses.serverErrR)
        }

    }

    private func handleResult<T: Encodable>(data: T, successHandler: (_ data: SData, _ statusCode: Status.Success) -> EventLoopFuture<Response>) -> EventLoopFuture<Response> {
        do {
            let jsonData = try JSONEncoder().encode(data)
            return successHandler(.json(JSONData(jsonData)), .OK)
        } catch {
            let errorMessage = "Error encoding data to JSON: \(error)"
            return self.sResponses.serverErrR(data: .json(JSONData(errorMessage)), statusCode: .INTERNAL_SERVER_ERROR)
        }
    }

    private func handleError(error: Error, errorHandler: (_ data: SData, _ statusCode: Status.ServerError) -> EventLoopFuture<Response>) -> EventLoopFuture<Response> {
        let errorMessage = "Something went wrong: \(error.localizedDescription)"
        return errorHandler(.json(JSONData(errorMessage)), .INTERNAL_SERVER_ERROR)
    }

    private func handleNotFound(message: String, notFoundHandler: (_ data: SData, _ statusCode: Status.ClientError) -> EventLoopFuture<Response>) -> EventLoopFuture<Response> {
        return notFoundHandler(.json(JSONData(message)), .BAD_REQUEST)
    }

}

