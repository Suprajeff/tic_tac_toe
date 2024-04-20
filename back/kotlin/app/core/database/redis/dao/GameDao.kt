class GameDao(private val syncCommands: RedisCommands<String, String>): GameDaoProtocol {

    override fun addPlayerMove(gameID: String, move: Move): Moves {
        syncCommands.sadd("$gameID:moves:${move.player}", move.position)
        val playerMoves = syncCommands.smembers("$gameID:moves:${move.player}")
        return Moves(move.player, playerMoves.toList())
    }
    
    override fun getPlayerMoves(gameID: String, move: Move): Moves {
        val playerMoves = syncCommands.smembers("$gameID:moves:${move.player}")
        return Moves(move.player, playerMoves.toList())
    }

    override fun getInfo(gameID: String): GameInfo {
        val info = syncCommands.hmget("$gameID:info", "currentPlayer", "gameState", "winner")
        val currentPlayer = info[0]
        val gameState = info[1]
        val winner = info[2]
        return GameInfo(currentPlayer, gameState, winner)
    }
    
    override fun updateInfo(gameID: String, info: GameInfo): GameInfo {
        syncCommands.hset("$gameID:info", mapOf(
            "currentPlayer" to info.currentPlayer,
            "gameState" to info.gameState,
            "winner" to info.winner
        ))
        return info
    }
    
}

interface GameDaoProtocol {
    fun addPlayerMove(gameID: String, move: Move): Moves
    fun getPlayerMoves(gameID: String, move: Move): Moves
    fun getInfo(gameID: string): GameInfo
    fun updateInfo(gameID: String, info: GameInfo): GameInfo
}