interface GameLogic {
    fun getNextPlayer(): Result<PlayerType>
    fun checkForWinner(): Result<PlayerType>
    fun checkForDraw(): Result<Boolean>
}