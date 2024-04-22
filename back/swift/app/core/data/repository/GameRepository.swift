import Foundation

protocol GameRepository {
    func createNewGame(newKey: String, board: BoardType, player: PlayerType) -> Result<GameType, Error>
    func resetGame(gameID: String, board: BoardType, player: PlayerType) -> Result<GameType, Error>
    func updateBoard(gameID: String, position: CellPosition, player: PlayerType) -> Result<GameType, Error>
    func getCurrentPlayer(gameID: String) -> Result<PlayerType, Error>
    func getBoardState(gameID: String) -> Result<BoardType, Error>
    func getGameState(gameID: String) -> Result<GameType, Error>
}