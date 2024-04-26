interface GameLogicB {
    fun generateNewID(): Result<String>
    fun generateNewBoard(): Result<BoardType>
    fun randomPlayer(): Result<PlayerType>
    fun getNextPlayer(currentPlayer: PlayerType): Result<PlayerType>
    fun checkForWinner(state: StateType): Result<Boolean, CellType?>
}

class GameLogic(): GameLogicB {

    override fun generateNewID(): Result<String> {
        val newID = UUID.randomUUID().toString()
        return Result.Success(newID)
    }

    override fun generateNewBoard(): Result<BoardType> {
        return Array(3) { Array(3) { null } }
    }

    override fun randomPlayer(): Result<PlayerType> {
        val symbols = listOf("X", "O").shuffled()
        val symbol = symbols.firstOrNull() ?: return Result.Failure(GameError.CouldNotGetPlayer)
        return Result.Success(PlayerType(symbol))
    }

    override fun getNextPlayer(currentPlayer: PlayerType): Result<PlayerType> {
        val nextSymbol = if (currentPlayer.symbol == "X") "O" else "X"
        return Result.Success(PlayerType(nextSymbol))
    }

    override fun checkForWinner(state: StateType): Result<Boolean, CellType?> {

        val cells: Map<CellPosition, CellType> = when (boardState) {
            is State.BoardState -> when (val boardType = boardState.board) {
                is BoardType.ArrayBoard -> boardType.cells.flatten().mapIndexed { index, cellType -> CellPosition.values()[index] to cellType }.toMap()
                is BoardType.DictionaryBoard -> boardType.cells
            }
            is State.MovesState -> boardState.moves.flatMap { (player, positions) -> positions.map { it to player } }.toMap()
        }

        for (combination in winningCombinationsForDictionary) {
            val (pos1, pos2, pos3) = combination
            val cell1 = cells[pos1]
            val cell2 = cells[pos2]
            val cell3 = cells[pos3]

            if (cell1 != null && cell2 != null && cell3 != null && cell1 == cell2 && cell2 == cell3) {
                return Result.success(true, cell1)
            }
        }

        return Result.success(false, null)

    }

}