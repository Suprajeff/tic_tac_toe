interface GameRepository {
    fun createNewGame(): Result<GameType, Error>
    fun resetGame(): Result<GameType, Error> 
    fun updateBoard(row: Int, col: Int, player: PlayerType): Result<GameType, Error>
    fun switchCurrentPlayer(): Result<GameType, Error> 
    fun getCurrentPlayer(): Result<PlayerType, Error> 
    fun getBoardState(): Result<BoardType, Error>
    fun getGameState(): Result<GameType, Error>
}