import Foundation

class RedisData: RedisDataProtocol {
    private let redis: Redis
    lazy var gameDao: GameDaoProtocol = GameDao(redis: redis)

    init(redis: Redis) {
        self.redis = redis
    }
}

protocol RedisDataProtocol {
    var gameDao: GameDaoProtocol { get }
}