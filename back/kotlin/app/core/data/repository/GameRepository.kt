package core.data.repository

import core.common.result.Result
import core.model.StateType
import core.model.PlayerType
import core.model.CellPosition
import core.model.GameType
import core.database.redis.entity.GameInfo

interface GameRepository {
    suspend fun createNewGame(newKey: String, board: StateType, player: PlayerType): Result<GameType>
    suspend fun resetGame(gameID: String, board: StateType, player: PlayerType): Result<GameType>
    suspend fun updateBoard(gameID: String, position: CellPosition, player: PlayerType): Result<StateType>
    suspend fun getCurrentPlayer(gameID: String): Result<PlayerType>
    suspend fun getBoardState(gameID: String): Result<StateType>
    suspend fun getGameState(gameID: String): Result<GameType>
    suspend fun updateGameState(gameID: String, board: StateType, info: GameInfo): Result<GameType>
}