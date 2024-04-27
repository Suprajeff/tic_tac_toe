sealed class State {
    data class BoardState(val board: BoardType) : State()
    data class MovesState(val moves: PlayersMoves) : State()
}

typealias StateType = State