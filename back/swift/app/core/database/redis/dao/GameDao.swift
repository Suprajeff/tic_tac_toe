import Foundation
import Redis

class GameDao: GameDaoProtocol {
    
    private let redis: RedisClient
    
    init(redis: RedisClient) {
        self.redis = redis
    }
    
    func addPlayerMove(gameID: String, move: Move) -> Result<Moves, Error> {
        do {
            try redis.sadd(move.position, to: "\(gameID):moves:\(move.player)").wait()
            let positions = try redis.smembers(of: "\(gameID):moves:\(move.player)").wait()
            let moves = Moves(player: move.player, positions: positions)
            return .success(moves)
        } catch {
            return .failure(error)
        }
    }

    func getPlayerMoves(gameID: String, move: Move) -> Result<Moves, Error> {
        do {
            let positions = try redis.smembers(of: "\(gameID):moves:\(move.player)").wait()
            let moves = Moves(player: move.player, positions: positions)
            return .success(moves)
        } catch {
            return .failure(error)
        }
    }

    func getInfo(gameID: String) -> Result<GameInfo, Error> {
        do {
            let info = try redis.hmget(["currentPlayer", "gameState", "winner"], from: "\(gameID):info").wait()
            let currentPlayer = info[0]
            let gameState = info[1]
            let winner = info[2]
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