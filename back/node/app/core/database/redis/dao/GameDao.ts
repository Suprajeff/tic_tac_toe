import {RedisClientType} from "redis";
import { Move, Moves } from "../entity/Move";
import { GameInfo } from "../entity/GameInfo";

class GameDao {
    
    private redis: RedisClientType;
    
    constructor(redis: RedisClientType) {
        this.redis = redis
    }
    
    
}

interface GameDaoProtocol {
    addPlayerMove(move: Move): Moves
    getPlayerMoves(move: Move): Moves
    getInfo(gameID: string): GameInfo
    updateInfo(): GameInfo
}

export {GameDao}