package core.model

import kotlinx.serialization.Serializable

@Serializable
data class PlayerType(val symbol: CellType)