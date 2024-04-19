import Foundation

enum BoardCells {
    arrayOfArrays([[CellType]])
    dictionary([CellPosition: CellType])
}

struct BoardType {
    var cells: BoardCells
}