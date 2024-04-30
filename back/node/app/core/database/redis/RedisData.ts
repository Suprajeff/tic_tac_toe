import {RedisClientType} from "redis";
import {GameDao} from "./dao/GameDao.js";

class RedisData {

    private readonly redis: RedisClientType;
    public gameDao: GameDao

    constructor(redis: RedisClientType) {
        this.redis = redis
        this.gameDao = new GameDao(this.redis)
    }

}

export {RedisData}