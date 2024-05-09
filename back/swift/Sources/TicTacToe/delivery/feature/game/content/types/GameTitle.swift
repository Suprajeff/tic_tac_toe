import Foundation

enum GameTitle: String, Codable {
    case PlayerXWon = "Player X Won"
    case PlayerOWon = "Player O Won"
    case Playing = "Playing"
    case Draw = "Draw"
}