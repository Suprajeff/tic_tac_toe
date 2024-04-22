import Foundation

struct Game {
    var id: String
    var moves: [CellType: [CellPosition]]
    var currentPlayer: PlayerType
    var gameState: GameState
    var winner: PlayerType?
}