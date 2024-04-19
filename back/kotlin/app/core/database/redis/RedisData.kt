class RedisData(commands: RedisCommands<String, String>) : RedisDataProtocol {
    override val gameDao: GameDao = GameDao(commands)
}

interface RedisDataProtocol {
    val gameDao: GameDao
}

// To do
// private val syncCommands: RedisCommands<String, String> = redisClient.connect().sync()