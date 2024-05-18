package delivery.feature.game.content.types

import kotlinx.serialization.Serializable
import kotlinx.serialization.Serializer
import kotlinx.serialization.descriptors.PrimitiveKind
import kotlinx.serialization.descriptors.PrimitiveSerialDescriptor
import kotlinx.serialization.encoding.Decoder
import kotlinx.serialization.encoding.Encoder
import kotlinx.serialization.json.Json
import kotlinx.serialization.KSerializer

@Serializable
data class GameSession(
    val gameID: String? = null,
    val currentPlayer: PlayerType? = null,
    val gameState: GameState? = null,
    val state: String? = null,
    val winner: PlayerType? = null
)

//val sessionData = call.sessions.get<GameSession>()
//
//val stateObject: StateType? = sessionData?.state?.let { serializedState ->
//    when (serializedState.startsWith("{\"board\"")) {
//        true -> Json.decodeFromString(State.BoardState.serializer(), serializedState)
//        false -> Json.decodeFromString(State.MovesState.serializer(), serializedState)
//    }
//}