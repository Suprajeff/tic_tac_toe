import Foundation

protocol GameUseCasesB {
    func initializeGame() -> Result<GameType, Error>
    func resetGame(gameID: String) -> Result<GameType, Error>
    func makeMove(gameID: String, position: CellPosition, player: PlayerType) -> Result<GameType, Error>
}

class GameUseCases: GameUseCasesB {

    func initializeGame() -> Result<GameType, Error> {

    }

    func resetGame(gameID: String) -> Result<GameType, Error> {

    }

    func makeMove(gameID: String, position: CellPosition, player: PlayerType) -> Result<GameType, Error> {

    }

}