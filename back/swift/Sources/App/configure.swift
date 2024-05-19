import Foundation
import Vapor
import Logging

public func configure(_ app: Application) async throws {

    app.logger.logLevel = .debug

    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .any(["http://localhost:8085"]),
        allowedMethods: [.GET, .POST, .OPTIONS],
        allowedHeaders: ["Accept", "Content-Type", "Content-Length", "Accept-Encoding", "X-CSRF-Token", "Authorization", "hx-target", "hx-current-url", "hx-trigger", "hx-request", "hx-boost", "hx-ext", "hx-get", "hx-swap"],
        allowCredentials: true
    )
    let cors = CORSMiddleware(configuration: corsConfiguration)

    try await redisSetup(app)

    let redisClient = app.redis

    app.logger.info("Launching game features...")
    let gameFeatureController = try await launchGameFeature(redisClient: redisClient, app)
    app.logger.info("Registering routes...")
    app.middleware.use(cors, at: .beginning)
    try app.routes.register(collection: GameEndpoints(gameController: gameFeatureController))
    app.get("hi") { req in
        return "Hi, vapor!"
    }
    app.get("ho") { req -> String in
        return "Ho, vapor!"
    }
    try routes(app)
    app.logger.info("Routes registered")
    print(app.routes.all)

}