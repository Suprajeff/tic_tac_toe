import Foundation

enum State: Codable {
    case board(BoardType)
    case moves(PlayersMoves)
}

typealias StateType = State