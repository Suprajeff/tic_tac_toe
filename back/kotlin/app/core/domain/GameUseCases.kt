interface GameUseCases {
    fun initializeGame(): Flow<Result<GameType>>
    fun resetGame(): Result<GameType>
    fun makeMove(row: Int, col: Int, player: PlayerType): Result<GameType>
}