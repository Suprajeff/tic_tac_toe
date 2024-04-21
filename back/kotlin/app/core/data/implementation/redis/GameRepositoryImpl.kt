class GameRepositoryImpl(private val redisData: RedisDataProtocol): GameRepository {
    
    override fun createNewGame(): Result<GameType, Error> {
        
    }
    
    override fun resetGame(): Result<GameType, Error> {
        
    }
    
    override fun updateBoard(row: Int, col: Int, player: PlayerType): Result<GameType, Error>{
        
    }
    
    override fun switchCurrentPlayer(): Result<GameType, Error> {
        
    }
    
    override fun getCurrentPlayer(): Result<PlayerType, Error> {
        
    }
    
    override fun getBoardState(): Result<BoardType, Error>{
        
    }
    
}