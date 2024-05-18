package core.database.redis.dao

import io.lettuce.core.RedisClient
import io.lettuce.core.api.async.RedisAsyncCommands
import kotlinx.coroutines.future.await

class GameDao(private val asyncCommands: RedisAsyncCommands<String, String>): GameDaoProtocol {

    override suspend fun setGame(newKey: String, board: StateType, player: PlayerType): Result<GameType> {

        return try {

            val playerRecord = Converter.playerTypeToStringRepresentation(player)

            asyncCommands.hset("$newKey:info", mapOf(
                "currentPlayer" to playerRecord,
                "gameState" to "IN_PROGRESS"
            )).await()

            Result.Success(GameType(newKey, player, GameState.IN_PROGRESS, board, null))

        } catch (e: Exception) {
            Result.Error(e)
        }
    }

    override suspend fun resetGame(gameID: String, board: StateType, player: PlayerType): Result<GameType> {

        return try {

            val playerRecord = Converter.playerTypeToStringRepresentation(player)

            asyncCommands.del("$gameID:moves:X", "$gameID:moves:O").await()
            asyncCommands.hdel("$gameID:info", "winner").await()
            asyncCommands.hset("$gameID:info", mapOf(
                "currentPlayer" to playerRecord,
                "gameState" to "IN_PROGRESS"
            )).await()
            Result.Success(GameType(gameID, player, GameState.IN_PROGRESS, board, null))

        } catch (e: Exception) {
            Result.Error(e)
        }
    }

    override suspend fun addPlayerMove(gameID: String, move: Move): Result<StateType> {

        return try {

            val moveRecord = Converter.cellPositionToStringRepresentation(move.position)

            asyncCommands.sadd("$gameID:moves:${move.player.symbol}", moveRecord).await()
            val xMoves = asyncCommands.smembers("$gameID:moves:X").await().map { position -> CellPosition.valueOf(position) }
            val oMoves = asyncCommands.smembers("$gameID:moves:O").await().map { position -> CellPosition.valueOf(position) }
            Result.Success(State.MovesState(mapOf(CellType.X to xMoves, CellType.O to oMoves)))

        } catch (e: Exception) {
            Result.Error(e)
        }
    }
    
    override suspend fun getPlayerMoves(gameID: String, move: Move): Result<Moves> {

        return try {

            val playerMoves = asyncCommands.smembers("$gameID:moves:${move.player}").await()

            val cellPositions = playerMoves.mapNotNull { move ->
                try {
                    CellPosition.valueOf(move)
                } catch (e: IllegalArgumentException) {
                    // Handle invalid strings here, if needed
                    null
                }
            }

            Result.Success(Moves(move.player, cellPositions.toList()))

        } catch (e: Exception) {
            Result.Error(e)
        }

    }

    override suspend fun getInfo(gameID: String): Result<GameType> {

        return try {

            val info = asyncCommands.hmget("$gameID:info", "currentPlayer", "gameState", "winner").await()
            val xMoves = asyncCommands.smembers("$gameID:moves:X").await().map { position -> CellPosition.valueOf(position) }
            val oMoves = asyncCommands.smembers("$gameID:moves:O").await().map { position -> CellPosition.valueOf(position) }

            val currentPlayer = Converter.stringToPlayerType(info[0].value)
            val gameState = Converter.stringToGameState(info[1].value)
            val winner = Converter.stringToPlayerType(info[2].value)
            if(currentPlayer === null){
                return Result.Error(IllegalStateException("Could not retrieve current player"))
            }

            Result.Success(GameType(gameID, currentPlayer, gameState, State.MovesState(mapOf(CellType.X to xMoves, CellType.O to oMoves)), winner))

        } catch (e: Exception) {
            Result.Error(e)
        }


    }

    override suspend fun updateInfo(gameID: String, board: StateType, info: GameInfo): Result<GameType> {

        return try {

            asyncCommands.hset("$gameID:info", mapOf(
                "currentPlayer" to info.currentPlayer.toString(),
                "gameState" to info.gameState.toString(),
                "winner" to info.winner.toString()
            )).await()
            Result.Success(GameType(gameID, info.currentPlayer, info.gameState, board, info.winner))

        } catch (e: Exception) {
            Result.Error(e)
        }

    }
    
}

interface GameDaoProtocol {
    suspend fun setGame(newKey: String, board: StateType, player: PlayerType): Result<GameType>
    suspend fun resetGame(gameID: String, board: StateType, player: PlayerType): Result<GameType>
    suspend fun addPlayerMove(gameID: String, move: Move): Result<StateType>
    suspend fun getPlayerMoves(gameID: String, move: Move): Result<Moves>
    suspend fun getInfo(gameID: String): Result<GameType>
    suspend fun updateInfo(gameID: String, board: StateType, info: GameInfo): Result<GameType>
}