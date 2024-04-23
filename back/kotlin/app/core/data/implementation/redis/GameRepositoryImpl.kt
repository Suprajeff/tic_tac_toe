class GameRepositoryImpl(private val redisData: RedisDataProtocol): GameRepository {
    
    override fun createNewGame(newKey: string, board: BoardType, player: PlayerType): Result<GameType, Error> {
        
    }
    
    override fun resetGame(gameID: string, board: BoardType, player: PlayerType): Result<GameType, Error> {
        
    }
    
    override fun updateBoard(gameID: string, position: CellPosition, player: PlayerType): Result<GameType, Error>{
        
    }
    
    override fun getCurrentPlayer(gameID: string): Result<PlayerType, Error> {
        
    }
    
    override fun getBoardState(gameID: string): Result<StateType, Error>{
        
    }

    override fun getGameState(gameID: string): Result<GameType, Error>{

    }

}