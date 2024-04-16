import Foundation

struct GameType {
    var board: BoardType
    var currentPlayer: PlayerType
    var gameState: GameState
    var winner: PlayerType?
}