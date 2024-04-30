import java.io.File
import java.util.*

object EnvironmentLoader {
    private val env = loadEnv()

    fun getSessionSecret(): String = env["SESSION_SECRET"] ?: ""
    fun getRedisHost(): String = env["REDIS_HOST"] ?: ""

    private fun loadEnv(): Map<String, String> {
        val env = mutableMapOf<String, String>()
        val currentDir = File(System.getProperty("user.dir"))
        val envFile = File(currentDir.parentFile?.parentFile, ".env")

        if (envFile.exists()) {
            envFile.readLines().forEach { line ->
                val (key, value) = line.split("=", limit = 2)
                env[key] = value
            }
        }

        return env
    }
}