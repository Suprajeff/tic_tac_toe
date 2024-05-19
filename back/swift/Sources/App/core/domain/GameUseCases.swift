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

        guard case let .success(newKey) = newKey,
            case let .success(board) = board,
            case let .success(player) = player
        else {
            return .failure(CustomError("Something went wrong while initializing the game"))
        }

        return gameRepo.createNewGame(newKey: newKey, board: board, player: player)
    }

    func resetGame(gameID: String) -> Result<GameType, Error> {
        let board = gameLogic.generateNewBoard()
        let player = gameLogic.randomPlayer()
        guard case let .success(board) = board,
            case let .success(player) = player
        else {
            return .failure(CustomError("Something went wrong while initializing the game"))
        }
        return gameRepo.resetGame(gameID: gameID, board: board, player: player)
    }

    func makeMove(gameID: String, position: CellPosition, player: PlayerType) -> Result<GameType, Error> {

        let newBoardState = gameRepo.updateBoard(gameID: gameID, position: position, player: player)
        guard case let .success(newBoardState) = newBoardState else {
            return .failure(CustomError("something went wrong when trying to retrieve board state"))
        }

        let checkWinnerAndDraw = gameLogic.checkForWinner(state: newBoardState)

        var gameState: GameState
        var winner: PlayerType?

        switch checkWinnerAndDraw {
            case .success(let result):
                if(result.winner != nil){
                    winner = result.winner
                    gameState = .Won
                } else {
                    gameState = .Draw
                }
            case .failure(let error):
                return .failure(error)
            case .notFound:
                gameState = .InProgress
        }


        let nextPlayer = gameLogic.getNextPlayer(currentPlayer: player)
        guard case let .success(nextPlayer) = nextPlayer else {
                return .failure(CustomError("Something went wrong while getting next player"))
            }
        return gameRepo.updateGameState(gameID: gameID, board: newBoardState, info: GameInfo(currentPlayer: nextPlayer, gameState: gameState, winner: winner))
    }

}