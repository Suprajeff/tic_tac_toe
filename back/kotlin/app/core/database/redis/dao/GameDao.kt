class GameDao(private val syncCommands: RedisCommands<String, String>): GameDaoProtocol {

    override fun setGame(newKey: string, board: BoardType, player: PlayerType): GameType {
        syncCommands.hset("$newKey:info", mapOf(
            "currentPlayer" to player,
            "gameState" to "IN_PROGRESS"
        ))
        return GameType(newKey, player, GameState.InProgress, board, null)
    }

    override fun resetGame(gameID: string, board: BoardType, player: PlayerType): GameType {
        syncCommands.del("$gameID:moves:X", "$gameID:moves:O")
        syncCommands.hdel("$newKey:info", "winner")
        syncCommands.hset("$gameID:info", mapOf(
            "currentPlayer" to player,
            "gameState" to "IN_PROGRESS"
        ))
        return GameType(gameID, player, GameState.InProgress, board, null)
    }

    override fun addPlayerMove(gameID: String, move: Move): Moves {
        syncCommands.sadd("$gameID:moves:${move.player}", move.position)
        val playerMoves = syncCommands.smembers("$gameID:moves:${move.player}")
        return Moves(move.player, playerMoves.toList())
    }
    
    override fun getPlayerMoves(gameID: String, move: Move): Moves {
        val playerMoves = syncCommands.smembers("$gameID:moves:${move.player}")
        return Moves(move.player, playerMoves.toList())
    }

    override fun getInfo(gameID: String): GameType {

        val info = syncCommands.hmget("$gameID:info", "currentPlayer", "gameState", "winner")
        val xMoves = syncCommands.smembers("$gameID:moves:X")
        val oMoves = syncCommands.smembers("$gameID:moves:O")

        val currentPlayer = info[0]
        val gameState = info[1]
        val winner = info[2]

        return Game(gameID, currentPlayer, gameState, mapOf(CellType.X to xCellPositions, CellType.O to oCellPositions), winner)
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
    fun setGame(newKey: string, board: BoardType, player: PlayerType): GameType
    fun resetGame(gameID: string, board: BoardType, player: PlayerType): GameType
    fun addPlayerMove(gameID: String, move: Move): Moves
    fun getPlayerMoves(gameID: String, move: Move): Moves
    fun getInfo(gameID: string): GameType
    fun updateInfo(gameID: String, info: GameInfo): GameInfo
}