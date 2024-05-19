package core.database.redis

import io.lettuce.core.RedisClient
//import io.lettuce.core.api.sync.RedisCommands
import io.lettuce.core.api.async.RedisAsyncCommands
import core.database.redis.dao.GameDao

class RedisData(commands: RedisAsyncCommands<String, String>) : RedisDataProtocol {
    override val gameDao: GameDao = GameDao(commands)
}
