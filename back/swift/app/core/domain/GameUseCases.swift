import Foundation

protocol GameUseCasesB {
    func initializeGame() -> Result<GameType, Error>
    func resetGame(gameID: String) -> Result<GameType, Error>
    func makeMove(gameID: String, position: CellPosition, player: PlayerType) -> Result<GameType, Error>
}

class GameUseCases: GameUseCasesB {

    private let gameRepo: GameRepository
    private let gameLogic: GameLogicB

    init(repo: GameRepository, logic: GameLogicB) {
        self.gameRepo = repo
        self.gameLogic = logic
    }

    func initializeGame() -> Result<GameType, Error> {
        let newKey = gameLogic.generateNewID()
        let board = gameLogic.generateNewBoard()
        let player = gameLogic.randomPlayer()
        guard let newKey = newKey.data, let player = player.data else {
            return .failure(Error("something went wrong"))
        }
        return gameRepo.createNewGame(newKey, board, player)
    }

    func resetGame(gameID: String) -> Result<GameType, Error> {
        let board = gameLogic.generateNewBoard()
        let player = gameLogic.randomPlayer()
        guard let player = player.data else {
            return .failure(Error("something went wrong"))
        }
        return gameRepo.resetGame(gameID, board, player)
    }

    func makeMove(gameID: String, position: CellPosition, player: PlayerType) -> Result<GameType, Error> {
        let newBoardState = gameRepo.updateBoard(gameID, position, player)
        guard let newBoardState = newBoardState.data else {
            return .failure(Error("something went wrong when trying to retrieve board state"))
        }
        let checkWinnerAndDraw = gameLogic.checkForWinner(newBoardState)
        let nextPlayer = gameLogic.getNextPlayer(player)
        return gameRepo.getGameState(gameID)
    }

}