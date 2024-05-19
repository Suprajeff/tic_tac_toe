package delivery.middlewares

import io.ktor.server.application.Application
import io.ktor.server.application.install
import io.ktor.server.sessions.Sessions
import io.ktor.server.sessions.cookie
import delivery.feature.game.content.types.GameSession

fun Application.configureSession() {
    install(Sessions) {
        cookie<GameSession>("tictackotlin"){
            cookie.path = "/"
            cookie.maxAgeInSeconds = 30 * 24 * 60 * 60
            cookie.httpOnly = true
            cookie.extensions["SameSite"] = "lax"
        }
    }
}