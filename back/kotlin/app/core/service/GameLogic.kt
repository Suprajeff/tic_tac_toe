interface GameLogicB {
    fun generateNewID(): Result<String>
    fun generateNewBoard(): Result<BoardType>
    fun randomPlayer(): Result<PlayerType>
    fun getNextPlayer(currentPlayer: PlayerType): Result<PlayerType>
    fun checkForWinner(state: StateType): Result<PlayerType>
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

    override fun checkForWinner(state: StateType): Result<PlayerType> {

    }

}