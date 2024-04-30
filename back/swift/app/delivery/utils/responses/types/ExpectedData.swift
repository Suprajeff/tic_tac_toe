import Foundation

struct GameIDData: Content, Codable {
    let gameID: String
}

struct GameData: Content, Codable {
    let gameID: String
    let position: CellPosition
    let playerSymbol: CellType
}