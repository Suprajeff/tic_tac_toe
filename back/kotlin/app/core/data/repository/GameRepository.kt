interface GameRepository {
    fun createNewGame(newKey: string, board: BoardType, player: PlayerType): Result<GameType, Error>
    fun resetGame(gameID: string, board: BoardType, player: PlayerType): Result<GameType, Error>
    fun updateBoard(row: Int, col: Int, player: PlayerType): Result<GameType, Error>
    fun switchCurrentPlayer(gameID: string): Result<GameType, Error>
    fun getCurrentPlayer(gameID: string): Result<PlayerType, Error>
    fun getBoardState(gameID: string): Result<BoardType, Error>
    fun getGameState(gameID: string): Result<GameType, Error>
}