import java.io.File

fun main() {

    val redisClient: RedisCommands<String, String>? = try {
        createRedisClient()
    } catch (e: Exception) {
        println("Error creating Redis client: ${e.message}")
        return
    }

    redisClient?.let {
        val redisData = RedisData(it)
        lauchGameFeature(redisData)
    }

}