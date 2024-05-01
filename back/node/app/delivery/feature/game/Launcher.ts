import { createRedisClient } from "../../../connections/infrastructure/database/redis.js";
import { RedisData } from "../../../core/database/redis/RedisData.js";
import {GameRepositoryImpl} from "../../../core/data/implementation/redis/GameRepositoryImpl.js";
import {GameStateChecker} from "../../../core/service/game/GameStateChecker.js";
import {GameLogic} from "../../../core/service/game/GameLogic.js";
import {GameUseCases} from "../../../core/domain/GameUseCases.js";
import {GameResponses} from "../../utils/responses/SResponses.js";
import {GameController} from "./controllers/GameController.js";
import {GameEndpoints} from "./endpoints/GameEndpoints.js";
import { Router } from "express";

const launchGameFeature = async (client: RedisData, router: Router) =>{

    const gameRepository = new GameRepositoryImpl(client)

    const gameChecker = new GameStateChecker()
    const gameLogic = new GameLogic(gameChecker)

    const gameUseCases = new GameUseCases(gameRepository, gameLogic)
    const gameResponses = new GameResponses()

    const gameController = new GameController(gameUseCases, gameResponses)

    new GameEndpoints(gameController, router);

    console.log(`road ready: ${gameController}`)

}

export {launchGameFeature}