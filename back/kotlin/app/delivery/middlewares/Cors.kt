import io.ktor.server.application.*
import io.ktor.server.plugins.cors.*
import io.ktor.http.*
import io.ktor.server.response.*
import java.util.*
import io.ktor.server.engine.*
import io.ktor.server.netty.*

fun Application.configureCORS() {
    install(CORS) {
        allowCredentials = true
        allowNonSimpleContentTypes = true
        val corsOrigin = System.getenv("CORS_ORIGIN") ?: "localhost:8085"
        allowHost(corsOrigin, schemes = listOf("http"))
        allowMethod(HttpMethod.Head)
        allowMethod(HttpMethod.Get)
        allowMethod(HttpMethod.Post)
        allowMethod(HttpMethod.Options)
        allowMethod(HttpMethod.Put)
        allowHeader(HttpHeaders.ContentType)
        allowHeader(HttpHeaders.Authorization)
        allowHeader("hx-target")
        allowHeader("hx-current-url")
        allowHeader("hx-trigger")
        allowHeader("hx-request")
        allowHeader("hx-boost")
        allowHeader("hx-ext")
        allowHeader("hx-get")
        allowHeader("hx-swap")
    }
}