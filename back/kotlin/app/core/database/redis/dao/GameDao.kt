class GameDao(private val redisClient: RedisClient) : GameDaoProtocol {
    
    
    
}

interface GameDaoProtocol {
    fun addPlayerMove(move: Move): Moves
    fun getPlayerMoves(move: Move): Moves
    fun getInfo(gameID: string): GameInfo
    fun updateInfo(): GameInfo
}