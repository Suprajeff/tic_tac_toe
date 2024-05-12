import session from 'express-session';
import RedisStore from 'connect-redis';
import { SESSION_SECRET } from '../../../connections/config/environment.js';
import {RedisClientType} from "redis";

const createSessionMiddleware = (redisClient: RedisClientType) => {
    const store: RedisStore = new RedisStore({
        client: redisClient,
        prefix: "tictac:",
    });

    const sessionSecret = SESSION_SECRET ? SESSION_SECRET : "secret"

    return session({
        name: "tictacnode",
        store: store,
        secret: sessionSecret,
        resave: false,
        saveUninitialized: false,
        cookie: {
            domain: 'localhost',
            path: '/',
            maxAge: 1000 * 60 * 60 * 24 * 30, // 30 days
            secure: false,
            httpOnly: true,
            sameSite: 'none',
        }
    });
};

export {createSessionMiddleware}