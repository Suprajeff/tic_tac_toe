import java.io.File
import io.ktor.server.engine.*
import io.ktor.server.netty.*
import io.ktor.server.application.*
import io.lettuce.core.RedisClient
import io.lettuce.core.api.sync.RedisCommands

fun main() {

    val redisClient: RedisCommands<String, String>? = try {
        createRedisClient()
    } catch (e: Exception) {
        println("Error creating Redis client: ${e.message}")
        return
    }

    redisClient?.let {
        val redisData = RedisData(it)
        embeddedServer(Netty, port = 8082) {
            configureCORS()
            launchGameFeature(this, redisData)
        }.start(wait = true)
    }

}