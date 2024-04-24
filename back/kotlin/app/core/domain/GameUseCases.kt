interface GameUseCasesB {
    fun initializeGame(): Flow<Result<GameType>>
    fun resetGame(gameID: String): Result<GameType>
    fun makeMove(gameID: String, position: CellPosition, player: PlayerType): Result<GameType>
}

class GameUseCases(): GameUseCasesB {

    override fun initializeGame(): Flow<Result<GameType>> {

    }

    override fun resetGame(gameID: String): Result<GameType> {

    }

    override fun makeMove(gameID: String, position: CellPosition, player: PlayerType): Result<GameType> {

    }

}