package core.model

import kotlinx.serialization.Serializable

@Serializable
sealed class BoardType {
    @Serializable
    data class ArrayBoard(val cells: Array<Array<CellType?>>) : BoardType()
    @Serializable
    data class DictionaryBoard(val cells: Map<CellPosition, CellType?>) : BoardType()
}