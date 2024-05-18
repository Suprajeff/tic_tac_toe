package core.database.redis.entity

import core.model.GameState
import core.model.PlayerType

data class GameInfo (
    val gameState: GameState,
    val currentPlayer: PlayerType,
    val winner: PlayerType? = null
)