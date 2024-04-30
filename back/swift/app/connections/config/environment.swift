import Vapor
import Foundation

struct EnvironmentData {
    static func loadEnvironment() {
        
        guard let sessionSecret = Environment.get("SESSION_SECRET") else {
            fatalError("SESSION_SECRET environment variable is not set.")
        }

        guard let redisHost = Environment.get("REDIS_HOST") else {
            fatalError("REDIS_HOST environment variable is not set.")
        }
        
        print("Session Secret: \(sessionSecret)")
        print("Redis Host: \(redisHost)")
    }
}