class GameDao(private val syncCommands: RedisCommands<String, String>): GameDaoProtocol {

    override fun addPlayerMove(move: Move): Moves {
        syncCommands.sadd(move.player, move.position)
        val playerMoves = syncCommands.smembers(move.player)
        return Moves(move.player, playerMoves.toList())
    }
    
    override fun getPlayerMoves(move: Move): Moves {
        val playerMoves = syncCommands.smembers(move.player)
        return Moves(move.player, playerMoves.toList())
    }

    override fun getInfo(gameID: String): GameInfo {
        val info = syncCommands.hmget(gameID, "currentPlayer", "gameState", "winner")
        val currentPlayer = info[0]
        val gameState = info[1]
        val winner = info[2]
        return GameInfo(currentPlayer, gameState, winner)
    }
    
    override fun updateInfo(gameID: String, info: GameInfo): GameInfo {
        syncCommands.hset(gameID, mapOf(
            "currentPlayer" to info.currentPlayer,
            "gameState" to info.gameState,
            "winner" to info.winner
        ))
        return info
    }
    
}

interface GameDaoProtocol {
    fun addPlayerMove(move: Move): Moves
    fun getPlayerMoves(move: Move): Moves
    fun getInfo(gameID: string): GameInfo
    fun updateInfo(gameID: String, info: GameInfo): GameInfo
}