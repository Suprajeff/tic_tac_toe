interface GameStateCheckerB  {
    fun checkForVictoryOrDrawA(cells: Array<Array<CellType?>>): Result<GameResult>;
    fun checkForVictoryOrDrawB(cells: Map<CellPosition, CellType?>): Result<GameResult>;
    fun checkForVictoryOrDrawC(playersMoves: Map<CellType, List<CellPosition>>): Result<GameResult>;
}

class GameStateChecker(): GameStateCheckerB {

    override fun checkForVictoryOrDrawA(cells: Array<Array<CellType?>>): Result<GameResult> {

        for ((a, b, c) in winningCombinationsForArray) {
            val cell1 = cells[a / 3][a % 3]
            val cell2 = cells[b / 3][b % 3]
            val cell3 = cells[c / 3][c % 3]

            if (cell1 != null && cell1 == cell2 && cell2 == cell3) {
            return Result.Success(GameResult(PlayerType(cell1), false))
            }
        }

        val cellAvailable = cells.any { row -> row.any { cell -> cell == null } }
        return if (cellAvailable) Result.NotFound else Result.Success(GameResult(null, true))

    }

    override fun checkForVictoryOrDrawB(cells: Map<CellPosition, CellType?>): Result<GameResult> {

        for ((pos1, pos2, pos3) in winningCombinationsForDictionary) {
            val cell1 = cells[pos1]
            val cell2 = cells[pos2]
            val cell3 = cells[pos3]

            if (cell1 != null && cell1 == cell2 && cell2 == cell3) {
            return Result.Success(GameResult(PlayerType(cell1), false))
            }
        }

        val cellAvailable = cells.values.any { it == null }
        return if (cellAvailable) Result.NotFound else Result.Success(GameResult(null, true))

    }

    override fun checkForVictoryOrDrawC(playersMoves: Map<CellType, List<CellPosition>>): Result<GameResult> {

        val playersSymbols = listOf(CellType.X, CellType.O)

        val winningPlayer = playersSymbols.find { player ->
            val moves = playersMoves[player] ?: emptyList()
            winningCombinationsForDictionary.any { combination ->
                combination.toList().all { pos -> moves.contains(pos) }
            }
        }

        return if (winningPlayer != null) {
            Result.Success(GameResult(PlayerType(winningPlayer), false))
        } else {
            val cellAvailable = 9 - ((playersMoves[CellType.X]?.size ?: 0) + (playersMoves[CellType.O]?.size ?: 0))
            if (cellAvailable === 0) {
                Result.Success(GameResult(null, true))
            } else {
                Result.NotFound
            }
        }

    }

}