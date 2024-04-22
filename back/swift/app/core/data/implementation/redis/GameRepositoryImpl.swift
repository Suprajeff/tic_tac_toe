import Foundation

class GameRepositoryImpl: GameRepository {
    
    private let redisData: RedisDataProtocol
        
    init(redisData: RedisDataProtocol) {
        self.redisData = redisData
    }
    
    func createNewGame(newKey: String, board: BoardType, player: PlayerType) -> Result<GameType, Error> {
        
    }
    
    func resetGame(gameID: String, board: BoardType, player: PlayerType) -> Result<GameType, Error>  {
        
    }
    
    func updateBoard(gameID: String, position: CellPosition, player: PlayerType) -> Result<GameType, Error> {
        
    }
    
    func switchCurrentPlayer(gameID: String) -> Result<GameType, Error> {
        
    }
    
    func getCurrentPlayer(gameID: String) -> Result<PlayerType, Error> {
        
    }
    
    func getBoardState(gameID: String) -> Result<BoardType, Error> {
        
    }

    func getGameState(gameID: String) -> Result<GameType, Error> {

    }

}