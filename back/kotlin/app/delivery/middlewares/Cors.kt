import io.ktor.application.*
import io.ktor.features.*
import io.ktor.http.*
import io.ktor.response.*
import java.util.*

fun Application.configureCORS() {
    install(CORS) {
        val corsOrigin = System.getenv("CORS_ORIGIN") ?: "http://localhost:8085"
        method(HttpMethod.Options)
        method(HttpMethod.Get)
        method(HttpMethod.Post)
        header(HttpHeaders.Accept)
        header(HttpHeaders.ContentType)
        header(HttpHeaders.ContentLength)
        header(HttpHeaders.AcceptEncoding)
        header("X-CSRF-Token")
        header(HttpHeaders.Authorization)
        allowCredentials = true
        anyHost()
        host(corsOrigin, schemes = listOf("http", "https"))
    }
}