import CellType

sealed class BoardType {
    data class ArrayBoard(val cells: Array<Array<CellType>>) : BoardType()
    data class DictionaryBoard(val cells: Map<CellPosition, CellType>) : BoardType()
}