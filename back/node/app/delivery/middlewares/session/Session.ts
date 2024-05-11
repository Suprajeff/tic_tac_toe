import session from 'express-session';
import RedisStore from 'connect-redis';
import { SESSION_SECRET } from '../../../connections/config/environment.js';
import {RedisClientType} from "redis";

const createSessionMiddleware = (redisClient: RedisClientType) => {
    const store: RedisStore = new RedisStore({
        client: redisClient,
        prefix: "tictac_session:",
    });

    const sessionSecret = SESSION_SECRET ? SESSION_SECRET : "secret"
    
    console.log('setting session')
    console.log(sessionSecret)

    return session({
        name: "tictactoe_node_session",
        store: store,
        secret: sessionSecret,
        resave: false,
        saveUninitialized: false,
        cookie: {
            sameSite: false,
            secure: false,
            httpOnly: true,
            maxAge: 1000 * 60 * 60 * 24 * 30, // 30 days
        }
    });
};

export {createSessionMiddleware}