import java.io.File
import io.ktor.server.engine.*
import io.ktor.server.netty.*
import io.ktor.server.application.*
import io.lettuce.core.RedisClient
import io.lettuce.core.api.async.RedisAsyncCommands

import connections.infrastructure.database.createRedisClient
import core.database.redis.RedisData
import delivery.middlewares.configureCORS
import delivery.middlewares.configureSession
import delivery.middlewares.configureParser
import delivery.feature.game.launchGameFeature

fun main() {

    val redisClient: RedisAsyncCommands<String, String>? = try {
        createRedisClient()
    } catch (e: Exception) {
        println("Error creating Redis client: ${e.message}")
        return
    }

    redisClient?.let {
        val redisData = RedisData(it)
        embeddedServer(Netty, port = 8082) {
            configureCORS()
            configureSession()
            configureParser()
            launchGameFeature(this, redisData)
        }.start(wait = true)
    }

}