import Vapor

func main() {
    
    print("Starting Vapor application...")

    let app = Application()

    app.http.server.configuration.hostname = "localhost"
    app.http.server.configuration.port = 8083

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

