import Foundation

protocol GameUseCasesB {
    func initializeGame() -> Result<GameType, Error>
    func resetGame() -> Result<GameType, Error>
    func makeMove(row: Int, col: Int, player: PlayerType) -> Result<GameType, Error>
}