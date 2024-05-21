import Foundation
import Redis

class GameDao: GameDaoProtocol {
    
    private let redis: RedisClient
    
    init(redis: RedisClient) {
        self.redis = redis
    }
    
    func setGame(newKey: String, board: BoardType, player: PlayerType) async -> Result<GameType, Error> {

        do {
            guard let starter = TypeConverter.playerTypeToString(player) else {
                return .failure(CustomError("Failed to extract or convert data from Redis"))
            }
            _ = try redis.hmset(["currentPlayer": starter, "gameState": "IN_PROGRESS"], in: "\(newKey):info")
            let newGame = GameType(id: newKey, currentPlayer: player, gameState: .InProgress, state: .board(board), winner: nil)
            return .success(newGame)
        } catch {
            return .failure(error)
        }

    }

    func resetGame(gameID: String, board: BoardType, player: PlayerType) async -> Result<GameType, Error> {

        do {
            _ = try redis.delete(["\(gameID):moves:X", "\(gameID):moves:O"])
            _ = try redis.hdel(["winner"], from: "\(gameID):info")
            guard let starter = TypeConverter.playerTypeToString(player) else {
                return .failure(CustomError("Failed to extract or convert data from Redis"))
            }
            _ = try redis.hmset(["currentPlayer": starter, "gameState": "IN_PROGRESS"], in: "\(gameID):info")
            let newGame = GameType(id: gameID, currentPlayer: player, gameState: .InProgress, state: .board(board), winner: nil)
            return .success(newGame)
        } catch {
            return .failure(error)
        }

    }

    func addPlayerMove(gameID: String, move: Move) async -> Result<StateType, Error> {
        do {
            let cellPosition = TypeConverter.cellPositiontoString(move.position)
            _ = try redis.sadd(cellPosition, to: "\(gameID):moves:\(move.player.symbol)")
            let xPositions = try await redis.smembers(of: "\(gameID):moves:X").get()
            let oPositions = try await redis.smembers(of: "\(gameID):moves:O").get()

            var xCellPositions: [CellPosition] = []
            var oCellPositions: [CellPosition] = []

            for xPosition in xPositions {
                if let xRESPValueString = TypeConverter.extractString(from: xPosition) {
                    if let xCellPosition = TypeConverter.stringToCellPosition(xRESPValueString) {
                        xCellPositions.append(xCellPosition)
                    }
                }
            }

            for oPosition in oPositions {
                if let oRESPValueString = TypeConverter.extractString(from: oPosition) {
                    if let oCellPosition = TypeConverter.stringToCellPosition(oRESPValueString) {
                        oCellPositions.append(oCellPosition)
                    }
                }
            }

            let moves: PlayersMoves = [
                CellType.X: xCellPositions,
                CellType.O: oCellPositions
            ]

            return .success(StateType.moves(moves))
        } catch {
            return .failure(error)
        }
    }

    func getPlayerMoves(gameID: String, move: Move) async -> Result<Moves, Error> {
        do {
            let positions = try await redis.smembers(of: "\(gameID):moves:\(move.player)").get()
            var cellPositions: [CellPosition] = []
            for position in positions {
                if let RESPValueString = TypeConverter.extractString(from: position) {
                    if let cellPosition = TypeConverter.stringToCellPosition(RESPValueString) {
                        cellPositions.append(cellPosition)
                    }
                }
            }
            let moves = Moves(player: move.player, positions: cellPositions)
            return .success(moves)
        } catch {
            return .failure(error)
        }
    }

    func getInfo(gameID: String) async -> Result<GameType, Error> {
        do {
            let info = try await redis.hmget(["currentPlayer", "gameState", "winner"], from: "\(gameID):info").get()
            let xPositions = try await redis.smembers(of: "\(gameID):moves:X").get()
            let oPositions = try await redis.smembers(of: "\(gameID):moves:O").get()

            var xCellPositions: [CellPosition] = []
            var oCellPositions: [CellPosition] = []

            for xPosition in xPositions {
                if let xRESPValueString = TypeConverter.extractString(from: xPosition) {
                    if let xCellPosition = TypeConverter.stringToCellPosition(xRESPValueString) {
                        xCellPositions.append(xCellPosition)
                    }
                }
            }

            for oPosition in oPositions {
                if let oRESPValueString = TypeConverter.extractString(from: oPosition) {
                    if let oCellPosition = TypeConverter.stringToCellPosition(oRESPValueString) {
                        oCellPositions.append(oCellPosition)
                    }
                }
            }

            guard let currentPlayerString = TypeConverter.extractString(from: info[0]),
                  let currentPlayer = TypeConverter.stringToPlayerType(currentPlayerString),
                  let gameStateString = TypeConverter.extractString(from: info[1]),
                  let gameState = TypeConverter.stringToGameState(gameStateString),
                  let winnerString = TypeConverter.extractString(from: info[2]),
                  let winner = TypeConverter.stringToPlayerType(winnerString) else {
                return .failure(CustomError("Failed to extract or convert data from Redis"))
            }
            let gameInfo = GameType(id: gameID, currentPlayer: currentPlayer, gameState: gameState, state: .moves([.X: xCellPositions, .O: oCellPositions]), winner: winner)
            return .success(gameInfo)
        } catch {
            return .failure(error)
        }
    }

    func updateInfo(gameID: String, board: StateType, info: GameInfo) async -> Result<GameType, Error> {
        do {
            guard let currentPlayer = TypeConverter.playerTypeToString(info.currentPlayer),
                        let gameState = TypeConverter.gameStateToString(info.gameState) else {
                return .failure(CustomError("Failed to extract or convert data from Redis"))
            }

            if let winner = info.winner {
                guard let winnerFormatted = TypeConverter.playerTypeToString(winner) else {
                    return .failure(CustomError("Failed to convert player string to player type"))
                }
                _ = try await redis.hmset(["currentPlayer": currentPlayer, "gameState": gameState, "winner": winnerFormatted], in: "\(gameID):info")
            } else {
                _ = try await redis.hmset(["currentPlayer": currentPlayer, "gameState": gameState], in: "\(gameID):info")
            }

            let gameInfo = GameType(id: gameID, currentPlayer: info.currentPlayer, gameState: info.gameState, state: board, winner: info.winner)
            return .success(gameInfo)
        } catch {
            print("error updating info: \(error.localizedDescription)")
            return .failure(error)
        }
    }

}

protocol GameDaoProtocol {
    func setGame(newKey: String, board: BoardType, player: PlayerType) async -> Result<GameType, Error>
    func resetGame(gameID: String, board: BoardType, player: PlayerType) async -> Result<GameType, Error>
    func addPlayerMove(gameID: String, move: Move) async -> Result<StateType, Error>
    func getPlayerMoves(gameID: String, move: Move) async -> Result<Moves, Error>
    func getInfo(gameID: String) async -> Result<GameType, Error>
    func updateInfo(gameID: String, board: StateType, info: GameInfo) async -> Result<GameType, Error>
}