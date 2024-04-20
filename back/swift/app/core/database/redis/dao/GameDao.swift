import Foundation
import Redis

class GameDao: GameDaoProtocol {
    
    private let redis: RedisClient
    
    init(redis: RedisClient) {
        self.redis = redis
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

    func getInfo(gameID: String) -> Result<GameInfo, Error> {
        do {
            let info = try redis.hmget(["currentPlayer", "gameState", "winner"], from: "\(gameID):info").wait()
            let currentPlayerString = TypeConverter.extractString(from: info[0])
            let currentPlayer = TypeConverter.stringToPlayerType(currentPlayerString)
            let gameState = info[1]
            let winnerString = TypeConverter.extractString(from: info[2])
            let winner = TypeConverter.stringToPlayerType(winnerString)
            let gameInfo = GameInfo(currentPlayer: currentPlayer, gameState: gameState, winner: winner)
            return .success(gameInfo)
        } catch {
            return .failure(error)
        }
    }

    func updateInfo(gameID: String, info: GameInfo) -> Result<GameInfo, Error> {
        do {
            try redis.hmset(["currentPlayer": info.currentPlayer, "gameState": info.gameState, "winner": info.winner ?? ""], in: "\(gameID):info").wait()
            return .success(info)
        } catch {
            return .failure(error)
        }
    }

}

protocol GameDaoProtocol {
    func addPlayerMove(gameID: String, move: Move) -> Result<Moves, Error>
    func getPlayerMoves(gameID: String, move: Move) -> Result<Moves, Error>
    func getInfo(gameID: String) -> Result<GameInfo, Error>
    func updateInfo(gameID: String, info: GameInfo) -> Result<GameInfo, Error>
}