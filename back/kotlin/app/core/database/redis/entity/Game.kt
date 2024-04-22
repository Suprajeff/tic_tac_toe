data class Game(
    val id: String,
    val moves: Map<CellType, List<CellPosition>>,
    val currentPlayer: PlayerType,
    val gameState: GameState,
    val winner: PlayerType? = null
)