class GameRepositoryImpl(private val redisData: RedisDataProtocol): GameRepository {
    
    override fun createNewGame(newKey: String, board: StateType, player: PlayerType): Result<GameType> {
        return redisData.gameDao.setGame(newKey, board, player)
    }
    
    override fun resetGame(gameID: String, board: StateType, player: PlayerType): Result<GameType> {
        return redisData.gameDao.resetGame(gameID, board, player)
    }
    
    override fun updateBoard(gameID: String, position: CellPosition, player: PlayerType): Result<StateType>{
        return redisData.gameDao.addPlayerMove(gameID, Move(player, position))
    }
    
    override fun getCurrentPlayer(gameID: String): Result<PlayerType> {
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
    
    override fun getBoardState(gameID: String): Result<StateType>{
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

    override fun getGameState(gameID: String): Result<GameType>{
        return redisData.gameDao.getInfo(gameID)
    }

    override fun updateGameState(gameID: String, board: StateType, info: GameInfo): Result<GameType> {
        return redisData.gameDao.updateInfo(gameID, board, info)
    }

}