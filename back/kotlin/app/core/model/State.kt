package core.model

import kotlinx.serialization.Serializable

@Serializable
sealed class State {
    @Serializable
    data class BoardState(val board: BoardType) : State()
    @Serializable
    data class MovesState(val moves: PlayersMoves) : State()
}