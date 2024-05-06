import Vapor

func main() {
    
    do {

        print("Starting Vapor application...")

        let app = Application()

        app.http.server.configuration.hostname = "localhost"
        app.http.server.configuration.port = 8083

        let corsConfiguration = CORSMiddleware.Configuration(
            allowedOrigin: .any(["http://localhost:8085"]),
            allowedMethods: [.GET, .POST, .OPTIONS],
            allowedHeaders: ["Accept", "Content-Type", "Content-Length", "Accept-Encoding", "X-CSRF-Token", "Authorization"]
        )
        let cors = CORSMiddleware(configuration: corsConfiguration)

        try redisSetup(app)

        let redisClient = app.redis

        print("Launching game features...")
        let gameFeatureController = try launchGameFeature(redisClient: redisClient, app)
        print("Registering routes...")
        app.middleware.use(cors, at: .beginning)
        try app.routes.register(collection: GameEndpoints(gameController: gameFeatureController))
        print("Routes registered")
        print(app.routes.all)
        print("Starting Vapor server...")
        try app.run()

    } catch {
       print(error)
    }
    
}

main()

