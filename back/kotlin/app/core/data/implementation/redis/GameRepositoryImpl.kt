class GameRepositoryImpl(private val redisData: RedisDataProtocol): GameRepository {
    
    override fun createNewGame(newKey: string, board: BoardType, player: PlayerType): Result<GameType, Error> {
        return redisData.gameDao.setGame(newKey, board, player)
    }
    
    override fun resetGame(gameID: string, board: BoardType, player: PlayerType): Result<GameType, Error> {
        return redisData.gameDao.resetGame(gameID, board, player)
    }
    
    override fun updateBoard(gameID: string, position: CellPosition, player: PlayerType): Result<StateType, Error>{
        return redisData.gameDao.addPlayerMove(gameID, PlayerMove(player, position))
    }
    
    override fun getCurrentPlayer(gameID: string): Result<PlayerType, Error> {
        return when (val result = redisData.gameDao.getInfo(gameID)) {
            is Result.Success -> {
                println("Data: ${result.data}")
                Result.Success(result.data.currentPlayer.symbol)
            }
            is Result.Error -> {
                println("Error: ${result.exception}")
                Result.Error(result.exception)
            }
            Result.NotFound -> Result.NotFound
        }
    }
    
    override fun getBoardState(gameID: string): Result<StateType, Error>{
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

    override fun getGameState(gameID: string): Result<GameType, Error>{
        return redisData.gameDao.getInfo(gameID)
    }

    override fun updateGameState(gameID: String, board: StateType, info: GameInfo): Result<GameType, Error> {
        return redisData.gameDao.updateInfo(gameID, board, info)
    }

}