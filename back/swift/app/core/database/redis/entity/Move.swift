import Foundation

struct Move {
    var player: PlayerType
    var position: CellPosition
}

struct Moves {
    var player: PlayerType
    var positions: [CellPosition]
}