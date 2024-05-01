import Vapor

func main() {

    let app = Application()

    app.http.server.configuration.hostname = "localhost"
    app.http.server.configuration.port = 8083

    do {

        try launchGameFeature(app)

        try app.run()

    } catch {
       print(error)
    }
}
