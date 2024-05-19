import Foundation
import Vapor

func routes(_ app: Application) throws {
    app.get("helloo") { req -> String in
        return "Helloo, world!"
    }
}