import { createRedisClient } from "../../../connections/infrastructure/database/redis";
import { RedisData } from "../../../core/database/redis/RedisData";
import {GameRepositoryImpl} from "../../../core/data/implementation/redis/GameRepositoryImpl";
import {GameStateChecker} from "../../../core/service/game/GameStateChecker";
import {GameLogic} from "../../../core/service/game/GameLogic";
import {GameUseCases} from "../../../core/domain/GameUseCases";
import {GameResponses} from "../../utils/responses/SResponses";
import {GameController} from "./controllers/GameController";
import {GameEndpoints} from "./endpoints/GameEndpoints";
import { createExpressRouter, createExpressServer } from "../../../connections/infrastructure/server/express";

const init = async () =>{

    // Redis Client & Connect =================================================================
    const redisClient = createRedisClient();
    await redisClient.connect();

    const redisData = new RedisData(redisClient)
    const gameRepository = new GameRepositoryImpl(redisData)

    const gameChecker = new GameStateChecker()
    const gameLogic = new GameLogic(gameChecker)

    const gameUseCases = new GameUseCases(gameRepository, gameLogic)
    const gameResponses = new GameResponses()

    const gameController = new GameController(gameUseCases, gameResponses)

    // Express Router + HTTP Routes
    const router = createExpressRouter();

    new GameEndpoints(gameController, router);

    // Start Express Server ============================================================================
    const server = createExpressServer([], router);

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