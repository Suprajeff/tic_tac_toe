import Foundation

protocol GameRepository {
    func initializeGame() -> Result<GameType, Error>
    func getGame() -> Result<GameType, Error>
    func makeMove(row: Int, col: Int) -> Result<GameType, Error>
    func getNextPlayer() -> Result<PlayerType, Error>
    func checkForWinner() -> Result<PlayerType, Error>
    func checkForDraw() -> Result<Bool, Error>
}