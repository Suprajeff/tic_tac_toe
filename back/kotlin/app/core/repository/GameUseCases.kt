interface GameUseCases {
    fun initializeGame(): Flow<Result<GameType>>
    fun getGame(): Result<GameType>
    fun makeMove(row: Int, col: Int, player: PlayerType): Result<GameType>
    fun getNextPlayer(): Result<PlayerType>
    fun checkForWinner(): Result<PlayerType>
    fun checkForDraw(): Result<Boolean>
}