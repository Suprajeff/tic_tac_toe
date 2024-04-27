interface GameRepository {
    fun createNewGame(newKey: String, board: StateType, player: PlayerType): Result<GameType>
    fun resetGame(gameID: String, board: StateType, player: PlayerType): Result<GameType>
    fun updateBoard(gameID: String, position: CellPosition, player: PlayerType): Result<StateType>
    fun getCurrentPlayer(gameID: String): Result<PlayerType>
    fun getBoardState(gameID: String): Result<StateType>
    fun getGameState(gameID: String): Result<GameType>
    fun updateGameState(gameID: String, board: StateType, info: GameInfo): Result<GameType>
}