import Foundation
import Vapor
import Logging

public func configure(_ app: Application) async throws {

    app.logger.logLevel = .debug

    // CORS
    configureCORS(app)

    // Db
    try await redisSetup(app)

    // Session
    configureSession(app)

    // Routes
    try await launchGameFeature(app)

    // Server Config
    app.http.server.configuration.hostname = "0.0.0.0"
    app.http.server.configuration.port = 8083
    app.http.server.configuration.supportPipelining = true

}