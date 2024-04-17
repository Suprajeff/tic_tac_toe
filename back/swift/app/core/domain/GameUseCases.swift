import Foundation

protocol GameUseCases {
    func initializeGame() -> Result<GameType, Error>
    func getGame() -> Result<GameType, Error>
    func makeMove(row: Int, col: Int, player: PlayerType) -> Result<GameType, Error>
    func getNextPlayer() -> Result<PlayerType, Error>
    func checkForWinner() -> Result<PlayerType, Error>
    func checkForDraw() -> Result<Bool, Error>
}