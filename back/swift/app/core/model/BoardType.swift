import Foundation

enum BoardCells {
    case arrayOfArrays([[CellType?]])
    case dictionary([CellPosition: CellType?])
}

struct BoardType {
    var cells: BoardCells
}