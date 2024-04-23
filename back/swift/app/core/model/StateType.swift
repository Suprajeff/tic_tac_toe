import Foundation

enum State {
    case board(BoardType)
    case moves(PlayerMoves)
}

typealias StateType = State