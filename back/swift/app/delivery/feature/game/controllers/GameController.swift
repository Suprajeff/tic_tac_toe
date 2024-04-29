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
            do {
                let jsonData = try JSONEncoder().encode(data)
                return self.sResponses.successR(data: .json(JSONData(jsonData)), statusCode: .OK)
            } catch {
                let errorMessage = "Error encoding GameType to JSON: \(error)"
                return self.sResponses.serverErrR(data: .json(JSONData(errorMessage)), statusCode: .INTERNAL_SERVER_ERROR)
            }
        case .failure(let error):
            let errorMessage = "Something went wrong: \(error.localizedDescription)"
            return self.sResponses.serverErrR(data: .json(JSONData(errorMessage)), statusCode: .INTERNAL_SERVER_ERROR)
        case .notFound:
            return self.sResponses.clientErrR(JSONData("Not found"), statusCode: .BAD_REQUEST)
        }

    }

    func restartGame(_ req: Request) -> Response {

        let gameData = try req.content.decode(GameIDData.self)

        let gameID = gameData.gameID

        guard !gameID.isEmpty else {
            throw Abort(.badRequest)
        }

        switch useCases.resetGame(gameID: gameID) {
        case .success(let data):
            do {
                let jsonData = try JSONEncoder().encode(data)
                    return self.sResponses.successR(data: .json(JSONData(jsonData)), statusCode: .OK)
                } catch {
                    print("Error encoding GameType to JSON: \(error)")
                    return self.sResponses.serverErrR(data: "Error encoding GameType to JSON", statusCode: .INTERNAL_SERVER_ERROR)
                }
        case .failure(let error):
            return self.sResponses.serverErrR(data: "Something went wrong", statusCode: .INTERNAL_SERVER_ERROR)
        case .notFound:
            return self.sResponses.clientErrR(data: "Not found", statusCode: .BAD_REQUEST)
        }


    }

    func makeMove(_ req: Request) -> Response  {

        let gameData = try req.content.decode(GameData.self)

        let gameID = gameData.gameID
        let position = gameData.position
        let player = PlayerType(symbol: gameData.playerSymbol)

        switch useCases.makeMove(gameID: gameID, position: position, player: player) {
        case .success(let data):
            do {
                let jsonData = try JSONEncoder().encode(data)
                    return self.sResponses.successR(data: .json(JSONData(jsonData)), statusCode: .OK)
                } catch {
                    print("Error encoding GameType to JSON: \(error)")
                    return self.sResponses.serverErrR(data: "Error encoding GameType to JSON", statusCode: .INTERNAL_SERVER_ERROR)
                }
        case .failure(let error):
            return self.sResponses.serverErrR(data: "Something went wrong", statusCode: .INTERNAL_SERVER_ERROR)
        case .notFound:
            return self.sResponses.clientErrR(data: "Not found", statusCode: .BAD_REQUEST)
        }

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

