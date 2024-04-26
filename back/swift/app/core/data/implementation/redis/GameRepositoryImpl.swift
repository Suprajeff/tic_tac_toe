import Foundation

class GameRepositoryImpl: GameRepository {
    
    private let redisData: RedisDataProtocol
        
    init(redisData: RedisDataProtocol) {
        self.redisData = redisData
    }
    
    func createNewGame(newKey: String, board: BoardType, player: PlayerType) -> Result<GameType, Error> {
        return redisData.gameDao.setGame(newKey: newKey, board: board, player: player)
    }
    
    func resetGame(gameID: String, board: BoardType, player: PlayerType) -> Result<GameType, Error>  {
        return redisData.gameDao.resetGame(gameID: gameID, board: board, player: player)
    }
    
    func updateBoard(gameID: String, position: CellPosition, player: PlayerType) -> Result<StateType, Error> {
        return redisData.gameDao.addPlayerMove(gameID: gameID, move: Move(player: player, position: position))
    }
    
    func getCurrentPlayer(gameID: String) -> Result<PlayerType, Error> {
        switch redisData.gameDao.getInfo(gameID: gameID) {
                case .success(let data):
                    print("Data:", data)
                    return .success(data.currentPlayer)
                case .failure(let error):
                    print("Error:", error)
                    return .failure(error)
                case .notFound:
                    return .notFound
                }
    }
    
    func getBoardState(gameID: String) -> Result<StateType, Error> {
        switch redisData.gameDao.getInfo(gameID: gameID) {
            case .success(let data):
                print("Data:", data)
                return .success(data.state)
            case .failure(let error):
                print("Error:", error)
                return .failure(error)
            case .notFound:
                return .notFound
            }
    }

    func getGameState(gameID: String) -> Result<GameType, Error> {
        return redisData.gameDao.getInfo(gameID: gameID)
    }

    func updateGameState(gameID: String, board: StateType, info: GameInfo) -> Result<GameType, Error> {
        return redisData.gameDao.updateInfo(gameID: gameID, board: board, info: info)
    }

}