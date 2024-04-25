interface GameUseCasesB {
    fun initializeGame(): Result<GameType>
    fun resetGame(gameID: String): Result<GameType>
    fun makeMove(gameID: String, position: CellPosition, player: PlayerType): Result<GameType>
}

class GameUseCases(private val gameRepo: GameRepository, private val gameLogic: GameLogicB): GameUseCasesB {

    override fun initializeGame(): Result<GameType> {
        val newKey = gameLogic.generateNewID()
        val board = gameLogic.generateNewBoard()
        val player = gameLogic.randomPlayer()
        return if (player.status != "success") {
            Result.failure(GameType("something went wrong"))
        } else {
            gameRepo.createNewGame(newKey.data!!, board, player.data)
        }
    }

    override fun resetGame(gameID: String): Result<GameType> {
        val board = gameLogic.generateNewBoard()
        val player = gameLogic.randomPlayer()
        return if (player.status != "success") {
            Result.failure(GameType("something went wrong"))
        } else {
            gameRepo.resetGame(gameID, board, player.data!!)
        }
    }

    override fun makeMove(gameID: String, position: CellPosition, player: PlayerType): Result<GameType> {
        val newBoardState = gameRepo.updateBoard(gameID, position, player)
        if (newBoardState.status != "success") {
            return Result.failure(GameType("something went wrong when trying to retrieve board state"))
        }
        val checkWinnerAndDraw = gameLogic.checkForWinner(newBoardState.data!!)
        val nextPlayer = gameLogic.getNextPlayer(player)
        return gameRepo.getGameState(gameID)
    }

}