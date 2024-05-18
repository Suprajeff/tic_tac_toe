package core.model

data class GameType(
    val id: String,
    val currentPlayer: PlayerType,
    val gameState: GameState,
    val state: StateType,
    val winner: PlayerType? = null
)