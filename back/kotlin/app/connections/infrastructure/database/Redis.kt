package connections.infrastructure.database

import java.util.concurrent.ExecutionException
import io.lettuce.core.RedisClient
import io.lettuce.core.RedisURI
import io.lettuce.core.*
import io.lettuce.core.api.async.RedisAsyncCommands
//import io.lettuce.core.api.sync.RedisCommands
import io.lettuce.core.api.StatefulRedisConnection

fun createRedisClient(redisHost: String = "redis"): RedisAsyncCommands<String, String> {
    val uri = RedisURI.Builder
        .redis(redisHost, 6379)
        .build()

    println("Connecting to Redis at $redisHost")

    val client = RedisClient.create(uri)
 
    try {
        val connection = client.connect()
        return connection.async()
    } catch (e: ExecutionException) {
        throw RuntimeException(e.message, e)
    } finally {
        //client.shutdown()
    }
    
}