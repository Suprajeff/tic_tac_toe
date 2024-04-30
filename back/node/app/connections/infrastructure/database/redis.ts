import redis, {RedisClientType} from 'redis';
import {REDIS_HOST} from "../../config/environment.js";


export const createRedisClient = () => {

    const redisHost: string = REDIS_HOST || 'localhost';

    console.log(`Connecting to Redis at ${redisHost}`);

    const client: RedisClientType = redis.createClient({
        url: `redis://${redisHost}:6379`
    })

    client.on('ready', () => console.log('Server connected to Redis'));
    client.on('error', err => console.log('Redis error: ', err + ` Tried to Connect to ${redisHost}`));

    return client;
};