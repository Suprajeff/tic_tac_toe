package core.service.game

import java.util.UUID

interface GameLogicB {
    fun generateNewID(): Result<String>
    fun generateNewBoard(): Result<BoardType>
    fun randomPlayer(): Result<PlayerType>
    fun getNextPlayer(currentPlayer: PlayerType): Result<PlayerType>
    fun checkForWinner(state: StateType): Result<GameResult>
}

class GameLogic(private val checker: GameStateCheckerB): GameLogicB {

    override fun generateNewID(): Result<String> {
        val newID = UUID.randomUUID().toString()
        return Result.Success(newID)
    }

    override fun generateNewBoard(): Result<BoardType> {
        return Result.Success(BoardType.ArrayBoard(Array(3) { Array(3) { null } }))
    }

    override fun randomPlayer(): Result<PlayerType> {
        val symbols = listOf(CellType.X, CellType.O).shuffled()
        val symbol = symbols.firstOrNull() ?: return Result.Error(IllegalStateException("Could not get symbol"))
        return Result.Success(PlayerType(symbol))
    }

    override fun getNextPlayer(currentPlayer: PlayerType): Result<PlayerType> {
        val nextSymbol = if (currentPlayer.symbol == CellType.X) CellType.O else CellType.X
        return Result.Success(PlayerType(nextSymbol))
    }

    override fun checkForWinner(state: StateType): Result<GameResult> {

        return when (state) {
            is State.BoardState -> {
                when (val boardType = state.board) {
                    is BoardType.ArrayBoard -> checker.checkForVictoryOrDrawA(boardType.cells)
                    is BoardType.DictionaryBoard -> checker.checkForVictoryOrDrawB(boardType.cells)
                }
            }
            is State.MovesState -> {
                checker.checkForVictoryOrDrawC(state.moves)
            }
        }

    }

}