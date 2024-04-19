data class GameInfo (
    val gameState: GameState,
    val currentPlayer: PlayerType,
    val winner: PlayerType? = null
)