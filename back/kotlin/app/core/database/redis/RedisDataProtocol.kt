package core.database.redis

import core.database.redis.dao.GameDao

interface RedisDataProtocol {
    val gameDao: GameDao
}