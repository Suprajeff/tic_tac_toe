import Foundation

class GameDao {
    
    private let redis: Redis
    
    init(redis: Redis) {
        self.redis = redis
    }
    
    func addPlayerMove(move: Move) -> Result<Moves> {
        do {
            try redis.send(Operation.sadd(move.player, move.position)).wait()
            let positions = try redis.send(Operation.smembers(move.player)).wait()
            let moves = Moves(player: move.player, positions: positions)
            return .success(moves)
        } catch {
            return .failure(error)
        }
    }

    func getPlayerMoves(move: Move) -> Result<Moves> {
        do {
            let positions = try redis.send(Operation.smembers(move.player)).wait()
            let moves = Moves(player: move.player, positions: positions)
            return .success(moves)
        } catch {
            return .failure(error)
        }
    }

    func getInfo(gameID: String) -> Result<GameInfo> {
        do {
            let info = try redis.send(Operation.hmget(gameID, ["currentPlayer", "gameState", "winner"])).wait()
            let currentPlayer = info[0]
            let gameState = info[1]
            let winner = info[2]
            let gameInfo = GameInfo(currentPlayer: currentPlayer, gameState: gameState, winner: winner)
            return .success(gameInfo)
        } catch {
            return .failure(error)
        }
    }

    func updateInfo(gameID: String, info: GameInfo) -> Result<GameInfo> {
        do {
            try redis.send(Operation.hmset(gameID, ["currentPlayer": info.currentPlayer, "gameState": info.gameState, "winner": info.winner ?? ""])).wait()
            return .success(info)
        } catch {
            return .failure(error)
        }
    }

}

protocol GameDaoProtocol {
    func addPlayerMove(move: Move) -> Result<Moves>
    func getPlayerMoves(move: Move) -> Result<Moves>
    func getInfo(gameID: string) -> Result<GameInfo>
    func updateInfo(gameID: String, info: GameInfo) -> Result<GameInfo>
}