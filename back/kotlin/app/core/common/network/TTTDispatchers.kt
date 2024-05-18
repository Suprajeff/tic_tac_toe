package core.common.network

annotation class Dispatcher(val dispatcher: TTTDispatchers)

enum class TTTDispatchers {
    DEFAULT,
    IO
}