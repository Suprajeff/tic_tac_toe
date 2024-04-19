class RedisData(client: RedisClient) : RedisDataProtocol {
    override val gameDao: GameDao = GameDao(redisClient)
}

interface RedisDataProtocol {
    val gameDao: GameDao
}