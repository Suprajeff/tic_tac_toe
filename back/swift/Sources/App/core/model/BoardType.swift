import Foundation

enum BoardCells: Codable {
    case arrayOfArrays([[CellType?]])
    case dictionary([CellPosition: CellType?])
}

struct BoardType: Codable {
    var cells: BoardCells
}