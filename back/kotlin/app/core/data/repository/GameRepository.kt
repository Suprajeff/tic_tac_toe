interface GameRepository {
    fun createNewGame(newKey: string, board: BoardType, player: PlayerType): Result<GameType, Error>
    fun resetGame(gameID: string, board: BoardType, player: PlayerType): Result<GameType, Error>
    fun updateBoard(gameID: string, position: CellPosition, player: PlayerType): Result<StateType, Error>
    fun getCurrentPlayer(gameID: string): Result<PlayerType, Error>
    fun getBoardState(gameID: string): Result<StateType, Error>
    fun getGameState(gameID: string): Result<GameType, Error>
    fun updateGameState(gameID: String, board: StateType, info: GameInfo): Result<GameType, Error>
}