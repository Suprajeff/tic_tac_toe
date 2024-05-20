import Vapor

public func configureCORS(_ app: Application) {

    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .any(["http://localhost:8085"]),
        allowedMethods: [.GET, .POST, .OPTIONS],
        allowedHeaders: ["Accept", "Content-Type", "Content-Length", "Accept-Encoding", "X-CSRF-Token", "Authorization", "hx-target", "hx-current-url", "hx-trigger", "hx-request", "hx-boost", "hx-ext", "hx-get", "hx-swap"],
        allowCredentials: true
    )

    let cors = CORSMiddleware(configuration: corsConfiguration)

    app.middleware.use(cors, at: .beginning)

}

