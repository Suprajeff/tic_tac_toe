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
        return gameRepo.createNewGame(newKey: newKey, board: board, player: player)
    }

    func resetGame(gameID: String) -> Result<GameType, Error> {
        let board = gameLogic.generateNewBoard()
        let player = gameLogic.randomPlayer()
        guard let player = player.data else {
            return .failure(Error("something went wrong"))
        }
        return gameRepo.resetGame(gameID: gameID, board: board, player: player)
    }

    func makeMove(gameID: String, position: CellPosition, player: PlayerType) -> Result<GameType, Error> {

        let newBoardState = gameRepo.updateBoard(gameID: gameID, position: position, player: player)
        guard let newBoardState = newBoardState.data else {
            return .failure("something went wrong when trying to retrieve board state")
        }

        let checkWinnerAndDraw = gameLogic.checkForWinner(newBoardState)

        var gameState: GameState
        var winner: PlayerType?
        switch checkWinnerAndDraw {
            case .success(true, let winningSymbol):
                gameState = .Won
                winner = PlayerType(symbol: winningSymbol)
            case .success(false, nil):
                gameState = .InProgress
            case .failure(let error):
                return .failure(error)
        }


        let nextPlayer = gameLogic.getNextPlayer(currentPlayer: player)
        return gameRepo.updateGameState(gameID: gameID, board: newBoardState, info: GameInfo(currentPlayer: nextPlayer, gameState: gameState, winner: winner))
    }

}