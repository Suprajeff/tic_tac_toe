import BoardType
import PlayerType 
import GameState 

data class GameType(
    val board: BoardType,
    val currentPlayer: PlayerType,
    val gameState: GameState,
    val winner: PlayerType? = null
)