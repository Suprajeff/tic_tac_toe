package delivery.utils.responses.types

import kotlinx.serialization.Serializable
import kotlinx.serialization.decodeFromString
import kotlinx.serialization.json.Json
import io.ktor.server.request.receiveText

import core.model.CellType
import core.model.CellPosition

@Serializable
data class GameIDData(val gameID: String)

@Serializable
data class GameData(
    val gameID: String,
    val position: CellPosition,
    val playerSymbol: CellType
)