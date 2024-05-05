import Vapor

func main() {
    
    print("Starting Vapor application...")

    let app = Application()

    app.http.server.configuration.hostname = "localhost"
    app.http.server.configuration.port = 8083

    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .originBased(allowed: [Environment.get("CORS_ORIGIN") ?? "http://localhost:8085"]),
        allowedMethods: [.GET, .POST, .OPTIONS],
        allowedHeaders: ["Accept", "Content-Type", "Content-Length", "Accept-Encoding", "X-CSRF-Token", "Authorization"]
    )
    let cors = CORSMiddleware(configuration: corsConfiguration)
    app.middleware.use(cors, at: .beginning)

    do {

        try redisSetup(app)

        let redisClient = app.redis

        print("Launching game features...")
        try launchGameFeature(redisClient: redisClient, app)

        print("Starting Vapor server...")
        try app.run()

    } catch {
       print(error)
    }
    
}

main()

