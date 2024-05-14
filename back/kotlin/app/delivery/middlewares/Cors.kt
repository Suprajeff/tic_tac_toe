import io.ktor.application.*
import io.ktor.features.*
import io.ktor.http.*
import io.ktor.response.*
import java.util.*
import io.ktor.server.engine.*
import io.ktor.server.netty.*

fun Application.configureCORS() {
    install(CORS) {
        val corsOrigin = System.getenv("CORS_ORIGIN") ?: "http://localhost:8085"
        host(corsOrigin)
        header(HttpHeaders.ContentType)
        allowCredentials = true
        allowNonSimpleContentTypes = true
        allowHeaders = true
    }
}