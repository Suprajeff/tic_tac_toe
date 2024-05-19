import Vapor
import Logging
import NIOCore
import NIOPosix

@main
enum Entrypoint {
    static func main() async throws {

        var env = try Environment.detect()
        try LoggingSystem.bootstrap(from: &env)
        let app = try await Application.make(env)

        let executorTakeoverSuccess = NIOSingletons.unsafeTryInstallSingletonPosixEventLoopGroupAsConcurrencyGlobalExecutor()

        app.logger.debug("Running with \(executorTakeoverSuccess ? "SwiftNIO" : "standard") Swift Concurrency default executor")

        app.http.server.configuration.hostname = "localhost"
        app.http.server.configuration.port = 8083

        let corsConfiguration = CORSMiddleware.Configuration(
            allowedOrigin: .any(["http://localhost:8085"]),
            allowedMethods: [.GET, .POST, .OPTIONS],
            allowedHeaders: ["Accept", "Content-Type", "Content-Length", "Accept-Encoding", "X-CSRF-Token", "Authorization", "hx-target", "hx-current-url", "hx-trigger", "hx-request", "hx-boost", "hx-ext", "hx-get", "hx-swap"]
        )
        let cors = CORSMiddleware(configuration: corsConfiguration)

        do {

            try await redisSetup(app)

            let redisClient = app.redis

            app.logger.info("Launching game features...")
            let gameFeatureController = try await launchGameFeature(redisClient: redisClient, app)
            app.logger.info("Registering routes...")
            try app.middleware.use(cors, at: .beginning)
            try app.routes.register(collection: GameEndpoints(gameController: gameFeatureController))
            app.logger.info("Routes registered")
            print(app.routes.all)

        } catch {

            app.logger.report(error: error)
            print(error)
            try? await app.asyncShutdown()
            throw error

        }

        app.logger.info("Starting Vapor server...")
        //try app.run()
        try await app.execute()
        try await app.asyncShutdown()

    }
}

