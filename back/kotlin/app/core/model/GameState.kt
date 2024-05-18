import kotlinx.serialization.Serializable

@Serializable
enum class GameState {
    IN_PROGRESS,
    WON,
    DRAW
}