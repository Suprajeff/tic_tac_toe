package core.database.redis.entity

import core.model.PlayerType
import core.model.CellPosition

data class Move (
    val player: PlayerType,
    val position: CellPosition
)

data class Moves (
    val player: PlayerType,
    val positions: List<CellPosition>
)