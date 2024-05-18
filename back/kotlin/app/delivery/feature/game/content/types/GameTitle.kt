import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
enum class GameTitle {
    @SerialName("Player X Won")
    PLAYER_X_WON,

    @SerialName("Player O Won")
    PLAYER_O_WON,

    @SerialName("Playing")
    PLAYING,

    @SerialName("Draw")
    DRAW
}