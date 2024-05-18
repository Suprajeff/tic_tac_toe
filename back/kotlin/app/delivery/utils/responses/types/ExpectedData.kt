package delivery.utils.responses.types

import kotlinx.serialization.Serializable
import kotlinx.serialization.decodeFromString
import kotlinx.serialization.json.Json
import io.ktor.server.request.receiveText

@Serializable
data class GameIDData(val gameID: String)

@Serializable
data class GameData(
    val gameID: String,
    val position: CellPosition,
    val playerSymbol: CellType
)