package core.domain

import core.common.result.Result
import core.model.PlayerType
import core.model.CellPosition
import core.model.GameType

interface GameUseCasesB {
    suspend fun initializeGame(): Result<GameType>
    suspend fun resetGame(gameID: String): Result<GameType>
    suspend fun makeMove(gameID: String, position: CellPosition, player: PlayerType): Result<GameType>
}