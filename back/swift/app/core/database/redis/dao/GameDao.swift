import Foundation

class GameDao {
    
    private let redis: Redis
    
    init(redis: Redis) {
        self.redis = redis
    }
    
}

protocol GameDaoProtocol {
    func addPlayerMove(move: Move) -> Result<Moves>
    func getPlayerMoves(move: Move) -> Result<Moves>
    func getInfo(gameID: string) -> Result<GameInfo>
    func updateInfo() -> Result<GameInfo>
}