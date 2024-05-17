data class GameSession(
    val gameID: String? = null,
    val currentPlayer: PlayerType? = null,
    val gameState: GameState? = null,
    val state: StateType? = null,
    val winner: PlayerType? = null
)