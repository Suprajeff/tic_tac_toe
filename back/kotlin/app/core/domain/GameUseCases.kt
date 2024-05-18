package core.domain

import org.slf4j.LoggerFactory
interface GameUseCasesB {
    suspend fun initializeGame(): Result<GameType>
    suspend fun resetGame(gameID: String): Result<GameType>
    suspend fun makeMove(gameID: String, position: CellPosition, player: PlayerType): Result<GameType>
}

class GameUseCases(private val gameRepo: GameRepository, private val gameLogic: GameLogicB): GameUseCasesB {

    companion object {
        private val logger = LoggerFactory.getLogger(GameUseCases::class.java)
    }

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
        when (newBoardStateResult) {
            is Result.Success<StateType> -> {
                val data = newBoardStateResult.data
                logger.info("Newboard State Result: $data")
            }
            is Result.Error -> {
                val error = newBoardStateResult.exception
                logger.info("Newboard State Error: $error")
                return Result.Error(IllegalStateException("Error getting board: ${(newBoardStateResult as Result.Error).exception}"))
            }
            is Result.NotFound -> {
                logger.warn("Result not found")
                return Result.NotFound
            }
            else -> {
                logger.info("Case not covered")
                return Result.NotFound
            }
        }

        var gameState: GameState = GameState.IN_PROGRESS
        var winner: PlayerType? = null

        val checkWinnerAndDrawResult = gameLogic.checkForWinner(newBoardStateResult.data)
        when (checkWinnerAndDrawResult) {
            is Result.Success<GameResult> -> {
                val data = checkWinnerAndDrawResult.data
                logger.info("Winner Check Result: $data")
                if (checkWinnerAndDrawResult.data.winner != null){
                    gameState = GameState.WON
                    winner = checkWinnerAndDrawResult.data.winner
                } else if(checkWinnerAndDrawResult.data.draw){
                    gameState = GameState.DRAW
                }
            }
            is Result.Error -> {
                val error = checkWinnerAndDrawResult.exception
                logger.info("Winner Check Error: $error")
                return Result.Error(IllegalStateException("Error checking for winner: ${(checkWinnerAndDrawResult as Result.Error).exception}"))
            }
            is Result.NotFound -> {
                logger.warn("Result not found")
            }
            else -> {
                logger.info("Case not covered")
            }
        }

        val nextPlayerResult = gameLogic.getNextPlayer(player)
        when (nextPlayerResult) {
            is Result.Success<PlayerType> -> {
                val data = nextPlayerResult.data
                logger.info("Next Player Result: $data")
            }
            is Result.Error -> {
                val error = nextPlayerResult.exception
                logger.info("Next Player Error: $error")
                return Result.Error(IllegalStateException("Error checking for winner: ${(nextPlayerResult as Result.Error).exception}"))
            }
            is Result.NotFound -> {
                logger.warn("Result not found")
                return Result.NotFound
            }
            else -> {
                logger.info("Case not covered")
                return Result.NotFound
            }
        }

        return gameRepo.updateGameState(gameID, newBoardStateResult.data, GameInfo(gameState, nextPlayerResult.data, winner))
    }

}