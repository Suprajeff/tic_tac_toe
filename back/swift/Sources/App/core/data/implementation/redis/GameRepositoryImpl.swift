import Foundation

class GameRepositoryImpl: GameRepository {
    
    private let redisData: RedisDataProtocol
        
    init(redisData: RedisDataProtocol) {
        self.redisData = redisData
    }
    
    func createNewGame(newKey: String, board: BoardType, player: PlayerType) async -> Result<GameType, Error> {
        return await redisData.gameDao.setGame(newKey: newKey, board: board, player: player)
    }
    
    func resetGame(gameID: String, board: BoardType, player: PlayerType) async -> Result<GameType, Error>  {
        return await redisData.gameDao.resetGame(gameID: gameID, board: board, player: player)
    }
    
    func updateBoard(gameID: String, position: CellPosition, player: PlayerType) async -> Result<StateType, Error> {
        return await redisData.gameDao.addPlayerMove(gameID: gameID, move: Move(player: player, position: position))
    }
    
    func getCurrentPlayer(gameID: String) async -> Result<PlayerType, Error> {
        switch await redisData.gameDao.getInfo(gameID: gameID) {
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
    
    func getBoardState(gameID: String) async -> Result<StateType, Error> {
        switch await redisData.gameDao.getInfo(gameID: gameID) {
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

    func getGameState(gameID: String) async -> Result<GameType, Error> {
        return await redisData.gameDao.getInfo(gameID: gameID)
    }

    func updateGameState(gameID: String, board: StateType, info: GameInfo) async -> Result<GameType, Error> {
        return await redisData.gameDao.updateInfo(gameID: gameID, board: board, info: info)
    }

}