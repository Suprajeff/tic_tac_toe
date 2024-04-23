import Foundation

struct GameType {
    var id: String
    var board: BoardType
    var currentPlayer: PlayerType
    var gameState: GameState
    var moves: PlayersMoves?
    var winner: PlayerType?
}