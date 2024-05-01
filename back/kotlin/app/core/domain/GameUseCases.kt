interface GameUseCasesB {
    suspend fun initializeGame(): Result<GameType>
    suspend fun resetGame(gameID: String): Result<GameType>
    suspend fun makeMove(gameID: String, position: CellPosition, player: PlayerType): Result<GameType>
}

class GameUseCases(private val gameRepo: GameRepository, private val gameLogic: GameLogicB): GameUseCasesB {

    override suspend fun initializeGame(): Result<GameType> {

        val newKeyResult = gameLogic.generateNewID()
        val boardResult = gameLogic.generateNewBoard()
        val playerResult = gameLogic.randomPlayer()

        when {
            newKeyResult is Result.Success<String> && boardResult is Result.Success<BoardType> && playerResult is Result.Success<PlayerType> -> {
                return gameRepo.createNewGame(newKeyResult.data, State.BoardState(boardResult.data), playerResult.data)
            }
            else -> {
                val errors = buildString {
                    if (newKeyResult !is Result.Success<String>) {
                        appendln("Error generating new ID: ${(newKeyResult as Result.Error).exception}")
                    }
                    if (boardResult !is Result.Success<BoardType>) {
                        appendln("Error generating new board: ${(boardResult as Result.Error).exception}")
                    }
                    if (playerResult !is Result.Success<PlayerType>) {
                        appendln("Error getting random player: ${(playerResult as Result.Error).exception}")
                    }
                }
                return Result.Error(IllegalStateException("Game initialization failed: $errors"))
            }
        }

    }

    override suspend fun resetGame(gameID: String): Result<GameType> {

        val boardResult = gameLogic.generateNewBoard()
        val playerResult = gameLogic.randomPlayer()


        when {
            boardResult is Result.Success<BoardType> && playerResult is Result.Success<PlayerType> -> {
                return gameRepo.resetGame(gameID, State.BoardState(boardResult.data), playerResult.data)
            }
            else -> {
                val errors = buildString {
                    if (boardResult !is Result.Success<BoardType>) {
                        appendln("Error generating new board: ${(boardResult as Result.Error).exception}")
                    }
                    if (playerResult !is Result.Success<PlayerType>) {
                        appendln("Error getting random player: ${(playerResult as Result.Error).exception}")
                    }
                }
                return Result.Error(IllegalStateException("Game initialization failed: $errors"))
            }
        }

    }

    override suspend fun makeMove(gameID: String, position: CellPosition, player: PlayerType): Result<GameType> {

        val newBoardStateResult = gameRepo.updateBoard(gameID, position, player)
        if (newBoardStateResult !is Result.Success<StateType>) {
            return Result.Error(IllegalStateException("Error getting board: ${(newBoardStateResult as Result.Error).exception}"))
        }

        val checkWinnerAndDrawResult = gameLogic.checkForWinner(newBoardStateResult.data)
        if (checkWinnerAndDrawResult !is Result.Success<GameResult>) {
            return Result.Error(IllegalStateException("Error checking for winner: ${(checkWinnerAndDrawResult as Result.Error).exception}"))
        }

        var gameState: GameState
        var winner: PlayerType? = null

        if (checkWinnerAndDrawResult.data.winner != null){
            gameState = GameState.WON
            winner = checkWinnerAndDrawResult.data.winner
        } else if(checkWinnerAndDrawResult.data.draw){
            gameState = GameState.DRAW
        } else {
            gameState = GameState.IN_PROGRESS
        }

        val nextPlayerResult = gameLogic.getNextPlayer(player)
        if (nextPlayerResult !is Result.Success<PlayerType>) {
            return Result.Error(IllegalStateException("Error getting player: ${(nextPlayerResult as Result.Error).exception}"))
        }

        return gameRepo.updateGameState(gameID, newBoardStateResult.data, GameInfo(gameState, nextPlayerResult.data, winner))
    }

}