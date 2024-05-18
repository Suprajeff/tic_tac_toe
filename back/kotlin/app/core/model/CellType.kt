package core.model

import kotlinx.serialization.Serializable

@Serializable
enum class CellType {
    X, O
}

// var emptyCell: CellType? = null