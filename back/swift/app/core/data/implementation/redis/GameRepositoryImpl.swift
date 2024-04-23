import Foundation

class GameRepositoryImpl: GameRepository {
    
    private let redisData: RedisDataProtocol
        
    init(redisData: RedisDataProtocol) {
        self.redisData = redisData
    }
    
    func createNewGame(newKey: String, board: BoardType, player: PlayerType) -> Result<GameType, Error> {
        return redisData.gameDao.setGame(newKey, board, player)
    }
    
    func resetGame(gameID: String, board: BoardType, player: PlayerType) -> Result<GameType, Error>  {
        return redisData.gameDao.resetGame(gameID, board, player)
    }
    
    func updateBoard(gameID: String, position: CellPosition, player: PlayerType) -> Result<StateType, Error> {
        return redisData.gameDao.addPlayerMove(gameID, PlayerMove(player: player, position: position))
    }
    
    func getCurrentPlayer(gameID: String) -> Result<PlayerType, Error> {
        switch redisData.gameDao.getInfo(gameID) {
                case .success(let data):
                    print("Data:", data)
                    return .success(data.currentPlayer.symbol)
                case .error(let error):
                    print("Error:", error)
                    return .failure(error)
                case .notFound:
                    return .notFound
                }
    }
    
    func getBoardState(gameID: String) -> Result<StateType, Error> {
        switch redisData.gameDao.getInfo(gameID) {
            case .success(let data):
                print("Data:", data)
                return .success(data.state)
            case .error(let error):
                print("Error:", error)
                return .failure(error)
            case .notFound:
                return .notFound
            }
    }

    func getGameState(gameID: String) -> Result<GameType, Error> {
        return redisData.gameDao.getInfo(gameID)
    }

}