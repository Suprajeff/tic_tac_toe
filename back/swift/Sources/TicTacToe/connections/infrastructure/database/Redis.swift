import Vapor
import Redis

public func redisSetup(_ app: Application) throws {
 
    let redisHost: String
    
    switch app.environment {
    case .production:
        guard let productionRedisHost = Environment.get("REDIS_HOST") else {
            throw Abort(.internalServerError, reason: "REDIS_HOST must be set in production environment")
        }
        redisHost = productionRedisHost
    case .development, .testing:
        redisHost = "redis"
    default:
        redisHost = "redis"
    }
    
    app.redis.configuration = try RedisConfiguration(
        hostname: "redis",
        port: 6379,
        password: nil
    )
    
    app.logger.info("Connecting to Redis at \(redisHost)")
    
}