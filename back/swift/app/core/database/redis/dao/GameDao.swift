import Foundation
import Redis

class GameDao: GameDaoProtocol {
    
    private let redis: RedisClient
    
    init(redis: RedisClient) {
        self.redis = redis
    }
    
    func setGame(newKey: String, board: BoardType, player: PlayerType) -> Result<GameType, Error> {

        do {
            guard let starter = TypeConverter.playerTypeToString(player) else {
                return .failure(GameInfoError("Failed to extract or convert data from Redis"))
            }
            _ = try redis.hmset(["currentPlayer": starter, "gameState": "IN_PROGRESS"], in: "\(newKey):info").wait()
            let newGame = GameType(id: newKey, board: board, currentPlayer: player, gameState: .InProgress, winner: nil)
            return .success(newGame)
        } catch {
            return .failure(error)
        }

    }

    func resetGame(gameID: String, board: BoardType, player: PlayerType) -> Result<GameType, Error> {

        do {
            _ = try redis.delete(["\(gameID):moves:X", "\(gameID):moves:O"]).wait()
            _ = try redis.hdel(["winner"], from: "\(gameID):info").wait()
            guard let starter = TypeConverter.playerTypeToString(player) else {
                return .failure(GameInfoError("Failed to extract or convert data from Redis"))
            }
            _ = try redis.hmset(["currentPlayer": starter, "gameState": "IN_PROGRESS"], in: "\(gameID):info").wait()
            let newGame = GameType(id: gameID, board: board, currentPlayer: player, gameState: .InProgress, winner: nil)
            return .success(newGame)
        } catch {
            return .failure(error)
        }

    }

    func addPlayerMove(gameID: String, move: Move) -> Result<Moves, Error> {
        do {
            let cellPosition = TypeConverter.cellPositiontoString(move.position)
            let newMove = try redis.sadd(cellPosition, to: "\(gameID):moves:\(move.player)").wait()
            print(newMove)
            let positions = try redis.smembers(of: "\(gameID):moves:\(move.player)").wait()
            var cellPositions: [CellPosition] = []
            for position in positions {
                if let RESPValueString = TypeConverter.extractString(from: position) {
                    if let cellPosition = TypeConverter.stringToCellPosition(RESPValueString){
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

    func getPlayerMoves(gameID: String, move: Move) -> Result<Moves, Error> {
        do {
            let positions = try redis.smembers(of: "\(gameID):moves:\(move.player)").wait()
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

    func getInfo(gameID: String) -> Result<Game, Error> {
        do {
            let info = try redis.hmget(["currentPlayer", "gameState", "winner"], from: "\(gameID):info").wait()
            let xPositions = try redis.smembers(of: "\(gameID):moves:X").wait()
            let oPositions = try redis.smembers(of: "\(gameID):moves:O").wait()

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
                return .failure(GameInfoError("Failed to extract or convert data from Redis"))
            }
            let gameInfo = Game(id: gameID, moves: [.X: xCellPositions, .O: oCellPositions] ,currentPlayer: currentPlayer, gameState: gameState, winner: winner)
            return .success(gameInfo)
        } catch {
            return .failure(error)
        }
    }

    func updateInfo(gameID: String, info: GameInfo) -> Result<GameInfo, Error> {
        do {
            guard let currentPlayer = TypeConverter.playerTypeToString(info.currentPlayer),
                        let gameState = TypeConverter.gameStateToString(info.gameState),
                        let winner = info.winner,
                        let winnerFormatted = TypeConverter.playerTypeToString(winner) else {
                return .failure(GameInfoError("Failed to extract or convert data from Redis"))
            }
            _ = try redis.hmset(["currentPlayer": currentPlayer, "gameState": gameState, "winner": winnerFormatted], in: "\(gameID):info").wait()
            return .success(info)
        } catch {
            return .failure(error)
        }
    }

}

protocol GameDaoProtocol {
    func setGame(newKey: String, board: BoardType, player: PlayerType) -> Result<GameType, Error>
    func resetGame(gameID: String, board: BoardType, player: PlayerType) -> Result<GameType, Error>
    func addPlayerMove(gameID: String, move: Move) -> Result<Moves, Error>
    func getPlayerMoves(gameID: String, move: Move) -> Result<Moves, Error>
    func getInfo(gameID: String) -> Result<Game, Error>
    func updateInfo(gameID: String, info: GameInfo) -> Result<GameInfo, Error>
}