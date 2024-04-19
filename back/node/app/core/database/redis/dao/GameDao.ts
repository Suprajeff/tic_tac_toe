import {RedisClientType} from "redis";

class GameDao {
    
    private redis: RedisClientType;
    
    constructor(redis: RedisClientType) {
        this.redis = redis
    }
    
    
    
}

export {GameDao}