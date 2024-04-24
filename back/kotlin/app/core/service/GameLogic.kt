interface GameLogicB {
    fun generateNewID(): Result<String>
    fun generateNewBoard(): Result<BoardType>
    fun randomPlayer(): Result<PlayerType>
    fun getNextPlayer(currentPlayer: PlayerType): Result<PlayerType>
    fun checkForWinner(state: StateType): Result<PlayerType>
    fun checkForDraw(state: StateType): Result<Boolean>
}

class GameLogic(): GameLogicB {

    override fun generateNewID(): Result<String> {

    }

    override fun generateNewBoard(): Result<BoardType> {

    }

    override fun randomPlayer(): Result<PlayerType> {

    }

    override fun getNextPlayer(currentPlayer: PlayerType): Result<PlayerType> {

    }

    override fun checkForWinner(state: StateType): Result<PlayerType> {

    }

    override fun checkForDraw(state: StateType): Result<Boolean> {
        
    }

}