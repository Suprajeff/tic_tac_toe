package core.database.redis.util

import core.model.CellPosition
import core.model.CellType
import core.model.PlayerType
import core.model.GameState
object Converter {
    
    fun cellPositionToStringRepresentation(cellPosition: CellPosition): String {
        return when (cellPosition) {
            CellPosition.TL -> "TL"
            CellPosition.T -> "T"
            CellPosition.TR -> "TR"
            CellPosition.L -> "L"
            CellPosition.C -> "C"
            CellPosition.R -> "R"
            CellPosition.BL -> "BL"
            CellPosition.B -> "B"
            CellPosition.BR -> "BR"
        }
    }

    fun stringToCellPosition(string: String): CellPosition? {
        return when (string) {
            "TL" -> CellPosition.TL
            "T" -> CellPosition.T
            "TR" -> CellPosition.TR
            "L" -> CellPosition.L
            "C" -> CellPosition.C
            "R" -> CellPosition.R
            "BL" -> CellPosition.BL
            "B" -> CellPosition.B
            "BR" -> CellPosition.BR
            else -> null
        }
    }

    fun stringToPlayerType(string: String): PlayerType? {
        val cellType = when (string) {
            "X" -> CellType.X
            "O" -> CellType.O
            else -> return null
        }
        return PlayerType(cellType)
    }

    fun playerTypeToStringRepresentation(playerType: PlayerType): String {
        return when (playerType.symbol) {
            CellType.X -> "X"
            CellType.O -> "O"
        }
    }

    fun stringToGameState(string: String): GameState {
        return when (string) {
            "IN_PROGRESS" -> GameState.IN_PROGRESS
            "WON" -> GameState.WON
            "DRAW" -> GameState.DRAW
            else -> GameState.IN_PROGRESS
        }
    }

    fun gameStateToStringRepresentation(gameState: GameState): String {
        return when (gameState) {
            GameState.IN_PROGRESS -> "IN_PROGRESS"
            GameState.WON -> "WON"
            GameState.DRAW -> "DRAW"
        }
    }
}