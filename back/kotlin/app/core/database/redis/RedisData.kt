import io.lettuce.core.RedisClient
//import io.lettuce.core.api.sync.RedisCommands
import io.lettuce.core.api.async.RedisAsyncCommands

class RedisData(commands: RedisAsyncCommands<String, String>) : RedisDataProtocol {
    override val gameDao: GameDao = GameDao(commands)
}

interface RedisDataProtocol {
    val gameDao: GameDao
}

// To do
// private val syncCommands: RedisCommands<String, String> = redisClient.connect().sync()