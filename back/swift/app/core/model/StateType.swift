import Foundation

enum State {
    case board(BoardType)
    case moves(PlayersMoves)
}

typealias StateType = State