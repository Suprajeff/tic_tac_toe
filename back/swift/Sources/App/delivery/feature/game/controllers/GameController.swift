import Foundation
import Vapor
import Logging

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
                req.session.data["gameID"] = data.id
                req.session.data["currentPlayer"] = TypeConverter.playerTypeToString(data.currentPlayer)
                req.session.data["gameState"] = TypeConverter.gameStateToString(data.gameState)
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

            guard let gameID = req.session.data["gameID"] else {
                return try handleNotFound(req: req, message: "Game ID cannot be null", notFoundHandler: self.sResponses.clientErrR)
            }

            switch await useCases.resetGame(gameID: gameID) {
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

            print("Start Making Move")

            let positionData = try req.content.decode(MoveData.self)

            print("Got Position Data \(positionData)")

            guard let position = TypeConverter.stringToCellPosition(positionData.position) else {
                return try handleNotFound(req: req, message: "Could not get cellposition from request", notFoundHandler: self.sResponses.clientErrR)
            }

            guard let gameID = req.session.data["gameID"] else {
                return try handleNotFound(req: req, message: "Game ID cannot be null", notFoundHandler: self.sResponses.clientErrR)
            }

            guard let currentPlayer = req.session.data["currentPlayer"] else {
                return try handleNotFound(req: req, message: "Current Player cannot be null", notFoundHandler: self.sResponses.clientErrR)
            }

            guard let player = TypeConverter.stringToPlayerType(currentPlayer) else {
                return try handleNotFound(req: req, message: "Could not convert player data to player type cannot be null", notFoundHandler: self.sResponses.clientErrR)
            }

            switch await useCases.makeMove(gameID: gameID, position: position, player: player) {
                case .success(let data):
                    print(data)
                    print("Setting Up Game Title")

                    let newTitle: GameTitle

                    if data.gameState == GameState.Won, let winner = data.winner {
                        newTitle = (winner.symbol == CellType.X) ? .PlayerXWon : .PlayerOWon
                    } else if data.gameState == GameState.Draw {
                        newTitle = .Draw
                    } else {
                        newTitle = .Playing
                    }

                    print("Updating Board")

                    switch data.state {
                        case .board(let boardType):
                            return try handleNotFound(req: req, message: "Wrong state type", notFoundHandler: self.sResponses.clientErrR)
                        case .moves(let playersMoves):
                            req.session.data["currentPlayer"] = TypeConverter.playerTypeToString(data.currentPlayer)
                            req.session.data["gameState"] = TypeConverter.gameStateToString(data.gameState)
                            let newMove = GameHTMLContent.getBoard(title: newTitle, state: playersMoves)
                            switch(newMove) {
                                case .success(let board):
                                    return try handleResult(req: req, data: board, successHandler: self.sResponses.successR)
                                case .failure(let error):
                                    print("Issue Setting Board")
                                    return try handleError(req: req, error: error, errorHandler: self.sResponses.serverErrR)
                                case .notFound:
                                    return try handleNotFound(req: req, message: "Not found", notFoundHandler: self.sResponses.clientErrR)
                            }
                    }

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
        if let stringData = data as? String {
            return try successHandler(req, .html(stringData), .OK)
        } else {
            do {
                let jsonData = try JSONEncoder().encode(data)
                return try successHandler(req, .json(JSONData(jsonData)), .OK)
            } catch {
                let errorMessage = "Error encoding data to JSON: \(error)"
                return try self.sResponses.serverErrR(req: req, data: .json(JSONData(errorMessage)), statusCode: .INTERNAL_SERVER_ERROR)
            }
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

