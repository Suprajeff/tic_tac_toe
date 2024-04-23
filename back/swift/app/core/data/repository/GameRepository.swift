import Foundation

protocol GameRepository {
    func createNewGame(newKey: String, board: BoardType, player: PlayerType) -> Result<GameType, Error>
    func resetGame(gameID: String, board: BoardType, player: PlayerType) -> Result<GameType, Error>
    func updateBoard(gameID: String, position: CellPosition, player: PlayerType) -> Result<StateType, Error>
    func getCurrentPlayer(gameID: String) -> Result<PlayerType, Error>
    func getBoardState(gameID: String) -> Result<StateType, Error>
    func getGameState(gameID: String) -> Result<GameType, Error>
}