interface GameStateChecker  {
    fun checkForVictoryOrDrawA(cells: Array<Array<CellType?>>): Result<GameResult>;
    fun checkForVictoryOrDrawB(cells: Map<CellPosition, CellType?>): Result<GameResult>;
    fun checkForVictoryOrDrawC(playersHands: Map<CellType, List<CellPosition>>): Result<GameResult>; 
}