interface GameLogic {
    fun generateNewID(): Result<String>
    fun generateNewBoard(): Result<BoardType>
    fun randomPlayer(): Result<PlayerType>
    fun getNextPlayer(): Result<PlayerType>
    fun checkForWinner(): Result<PlayerType>
    fun checkForDraw(): Result<Boolean>
}