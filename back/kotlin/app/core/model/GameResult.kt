package core.model

data class GameResult(
    val winner: PlayerType? = null,
    val draw: Boolean = false
)