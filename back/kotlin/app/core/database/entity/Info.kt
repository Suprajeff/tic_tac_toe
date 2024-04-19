data class Info (
    val gameState: GameState,
    val currentPlayer: PlayerType,
    val winner: PlayerType? = null
)