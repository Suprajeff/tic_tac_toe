package core.data.implementation.redis

class GameRepositoryImpl(private val redisData: RedisDataProtocol): GameRepository {
    
    override suspend fun createNewGame(newKey: String, board: StateType, player: PlayerType): Result<GameType> {
        return redisData.gameDao.setGame(newKey, board, player)
    }
    
    override suspend fun resetGame(gameID: String, board: StateType, player: PlayerType): Result<GameType> {
        return redisData.gameDao.resetGame(gameID, board, player)
    }
    
    override suspend fun updateBoard(gameID: String, position: CellPosition, player: PlayerType): Result<StateType>{
        return redisData.gameDao.addPlayerMove(gameID, Move(player, position))
    }
    
    override suspend fun getCurrentPlayer(gameID: String): Result<PlayerType> {
        return when (val result = redisData.gameDao.getInfo(gameID)) {
            is Result.Success -> {
                println("Data: ${result.data}")
                Result.Success(result.data.currentPlayer)
            }
            is Result.Error -> {
                println("Error: ${result.exception}")
                Result.Error(result.exception)
            }
            Result.NotFound -> Result.NotFound
        }
    }
    
    override suspend fun getBoardState(gameID: String): Result<StateType>{
        return when (val result = redisData.gameDao.getInfo(gameID)) {
                is Result.Success -> {
                    println("Data: ${result.data}")
                    Result.Success(result.data.state)
                }
                is Result.Error -> {
                    println("Error: ${result.exception}")
                    Result.Error(result.exception)
                }
                Result.NotFound -> Result.NotFound
            }
    }

    override suspend fun getGameState(gameID: String): Result<GameType>{
        return redisData.gameDao.getInfo(gameID)
    }

    override suspend fun updateGameState(gameID: String, board: StateType, info: GameInfo): Result<GameType> {
        return redisData.gameDao.updateInfo(gameID, board, info)
    }

}