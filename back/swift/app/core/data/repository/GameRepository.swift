import Foundation

protocol GameRepository {
    func createNewGame() -> Result<GameType, Error>
    func resetGame() -> Result<GameType, Error> 
    func updateBoard(row: Int, col: Int, player: PlayerType) -> Result<GameType, Error>
    func switchCurrentPlayer() -> Result<GameType, Error> 
    func getCurrentPlayer() -> Result<PlayerType, Error> 
    func getBoardState() -> Result<BoardType, Error>
    func getGameState() -> Result<GameType, Error>
}