import Foundation
import Redis

class RedisData: RedisDataProtocol {
    private let redis: RedisClient
    lazy var gameDao: GameDaoProtocol = GameDao(redis: redis)

    init(redis: RedisClient) {
        self.redis = redis
    }
}

protocol RedisDataProtocol {
    var gameDao: GameDaoProtocol { get }
}