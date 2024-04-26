interface GameStateCheckerB  {
    fun checkForVictoryOrDrawA(cells: Array<Array<CellType?>>): Result<GameResult>;
    fun checkForVictoryOrDrawB(cells: Map<CellPosition, CellType?>): Result<GameResult>;
    fun checkForVictoryOrDrawC(playersHands: Map<CellType, List<CellPosition>>): Result<GameResult>;
}

class GameStateChecker(): GameStateCheckerB {

    override fun checkForVictoryOrDrawA(cells: Array<Array<CellType?>>): Result<GameResult> {

    }

    override fun checkForVictoryOrDrawB(cells: Map<CellPosition, CellType?>): Result<GameResult> {

    }

    override fun checkForVictoryOrDrawC(playersHands: Map<CellType, List<CellPosition>>): Result<GameResult> {
        
    }

}