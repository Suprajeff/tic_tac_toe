import Foundation

enum GameState: String, Codable {
    case InProgress = "IN_PROGRESS"
    case Won = "WON"
    case Draw = "DRAW"
}