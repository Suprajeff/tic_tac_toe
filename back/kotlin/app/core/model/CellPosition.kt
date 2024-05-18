package core.model

import kotlinx.serialization.Serializable

@Serializable
enum class CellPosition {
    TL, T, TR, L, C, R, BL, B, BR
}