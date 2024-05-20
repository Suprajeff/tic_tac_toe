import Foundation

protocol GameRepository {
    func createNewGame(newKey: String, board: BoardType, player: PlayerType) async -> Result<GameType, Error>
    func resetGame(gameID: String, board: BoardType, player: PlayerType) async -> Result<GameType, Error>
    func updateBoard(gameID: String, position: CellPosition, player: PlayerType) async -> Result<StateType, Error>
    func getCurrentPlayer(gameID: String) async -> Result<PlayerType, Error>
    func getBoardState(gameID: String) async -> Result<StateType, Error>
    func getGameState(gameID: String) async -> Result<GameType, Error>
    func updateGameState(gameID: String, board: StateType, info: GameInfo) async -> Result<GameType, Error>
}