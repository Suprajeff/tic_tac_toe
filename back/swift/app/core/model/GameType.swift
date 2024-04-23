import Foundation

struct GameType {
    var id: String
    var currentPlayer: PlayerType
    var gameState: GameState
    var state: StateType
    var winner: PlayerType?
}