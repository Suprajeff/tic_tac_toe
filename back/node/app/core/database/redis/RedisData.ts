import {GameDao} from "./dao/GameDao";

class RedisData {

    private readonly redis: RedisClientType;
    public gameDao: GameDao

    constructor(redis: RedisClientType) {
        this.redis = redis
        this.gameDao = new GameDao(this.redis)
    }

}