import Foundation

class GameRepositoryImpl: GameRepository {
    
    private let redisData: RedisDataProtocol
        
    init(redisData: RedisDataProtocol) {
        self.redisData = redisData
    }
    
    func createNewGame() -> Result<GameType, Error> {
        
    }
    
    func resetGame() -> Result<GameType, Error>  {
        
    }
    
    func updateBoard(row: Int, col: Int, player: PlayerType) -> Result<GameType, Error> {
        
    }
    
    func switchCurrentPlayer() -> Result<GameType, Error> {
        
    }
    
    func getCurrentPlayer() -> Result<PlayerType, Error> {
        
    }
    
    func getBoardState() -> Result<BoardType, Error> {
        
    }
    
}