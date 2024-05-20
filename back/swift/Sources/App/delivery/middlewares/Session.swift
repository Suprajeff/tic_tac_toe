import Vapor
import Redis

public func configureSession(_ app: Application) {

    app.sessions.use(.redis)
    app.sessions.configuration.cookieName = "tictacswift"
    app.sessions.configuration.cookieFactory = { sessionID in
        .init(string: sessionID.string, isSecure: false)
    }
    app.middleware.use(app.sessions.middleware)

}

