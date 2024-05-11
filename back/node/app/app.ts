import { createRedisClient } from "./connections/infrastructure/database/redis.js";
import { createExpressRouter, createExpressServer } from "./connections/infrastructure/server/express.js";
import { RedisData } from "./core/database/redis/RedisData.js";
import { launchGameFeature } from "./delivery/feature/game/Launcher.js";
import {corsMiddleware} from "./delivery/middlewares/cors/Cors.js";
import { createSessionMiddleware } from "./delivery/middlewares/session/Session.js";

const init = async () => {

    // Redis Client & Connect =================================================================
    const redisClient = createRedisClient();
    await redisClient.connect();

    const redisData = new RedisData(redisClient)

    // Initialize Redis Session Store =========================================================================
    const sessionMiddleware = createSessionMiddleware(redisClient);

    // Express Router + HTTP Routes
    const router = createExpressRouter();
    await launchGameFeature(redisData, router)

    // Start Express Server ============================================================================
    createExpressServer([corsMiddleware, sessionMiddleware], router);

    // Ensure you call `client.quit()` when you are done with Redis
    process.on('exit', () => {
        redisClient.quit().then(() => {
            console.log('Redis client quit successfully');
            process.exit(0);
        }).catch((err: unknown) => {
            console.error('Error quitting Redis client:', err);
            process.exit(1);
        });
    });

    process.on('uncaughtException', (err) => {
        console.error('There was an uncaught error', err)
        process.exit(1) //mandatory (as per the Node.js docs)
    })

}

await init()