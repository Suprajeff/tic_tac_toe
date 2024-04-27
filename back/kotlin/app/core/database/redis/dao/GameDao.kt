import io.lettuce.core.*

class GameDao(private val syncCommands: RedisCommands<String, String>): GameDaoProtocol {

    override fun setGame(newKey: String, board: StateType, player: PlayerType): Result<GameType> {

        return try {

            syncCommands.hset("$newKey:info", mapOf(
                "currentPlayer" to player,
                "gameState" to "IN_PROGRESS"
            ))

            Result.Success(GameType(newKey, player, GameState.IN_PROGRESS, board, null))

        } catch (e: Exception) {
            Result.Error(e)
        }
    }

    override fun resetGame(gameID: String, board: StateType, player: PlayerType): Result<GameType> {

        return try {

            syncCommands.del("$gameID:moves:X", "$gameID:moves:O")
            syncCommands.hdel("$gameID:info", "winner")
            syncCommands.hset("$gameID:info", mapOf(
                "currentPlayer" to player,
                "gameState" to "IN_PROGRESS"
            ))
            Result.Success(GameType(gameID, player, GameState.IN_PROGRESS, board, null))

        } catch (e: Exception) {
            Result.Error(e)
        }
    }

    override fun addPlayerMove(gameID: String, move: Move): Result<StateType> {

        return try {

            syncCommands.sadd("$gameID:moves:${move.player}", move.position)
            val xMoves = syncCommands.smembers("$gameID:moves:X").map { position -> CellPosition.valueOf(position) }
            val oMoves = syncCommands.smembers("$gameID:moves:O").map { position -> CellPosition.valueOf(position) }
            Result.Success(State.MovesState(mapOf(CellType.X to xMoves, CellType.O to oMoves)))

        } catch (e: Exception) {
            Result.Error(e)
        }
    }
    
    override fun getPlayerMoves(gameID: String, move: Move): Result<Moves> {

        return try {

            val playerMoves = syncCommands.smembers("$gameID:moves:${move.player}")
            Result.Success(Moves(move.player, playerMoves.toList()))

        } catch (e: Exception) {
            Result.Error(e)
        }

    }

    override fun getInfo(gameID: String): Result<GameType> {

        return try {

            val info = syncCommands.hmget("$gameID:info", "currentPlayer", "gameState", "winner")
            val xMoves = syncCommands.smembers("$gameID:moves:X").map { position -> CellPosition.valueOf(position) }
            val oMoves = syncCommands.smembers("$gameID:moves:O").map { position -> CellPosition.valueOf(position) }

            val currentPlayer = info[0]
            val gameState = info[1]
            val winner = info[2]

            Result.Success(GameType(gameID, currentPlayer, gameState, State.MovesState(mapOf(CellType.X to xMoves, CellType.O to oMoves)), winner))

        } catch (e: Exception) {
            Result.Error(e)
        }


    }

    override fun updateInfo(gameID: String, board: StateType, info: GameInfo): Result<GameType> {

        return try {

            syncCommands.hset("$gameID:info", mapOf(
                "currentPlayer" to info.currentPlayer,
                "gameState" to info.gameState,
                "winner" to info.winner
            ))
            Result.Success(GameType(gameID, info.currentPlayer, info.gameState, board, info.winner))

        } catch (e: Exception) {
            Result.Error(e)
        }

    }
    
}

interface GameDaoProtocol {
    fun setGame(newKey: String, board: StateType, player: PlayerType): Result<GameType>
    fun resetGame(gameID: String, board: StateType, player: PlayerType): Result<GameType>
    fun addPlayerMove(gameID: String, move: Move): Result<StateType>
    fun getPlayerMoves(gameID: String, move: Move): Result<Moves>
    fun getInfo(gameID: String): Result<GameType>
    fun updateInfo(gameID: String, board: StateType, info: GameInfo): Result<GameType>
}