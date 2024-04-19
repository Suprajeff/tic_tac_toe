import {RedisClientType} from "redis";
import { Move, Moves } from "../entity/Move";
import { GameInfo } from "../entity/GameInfo";
import {Result} from "../../../common/result/Result";
import {CellPosition} from "../../../model/CellPosition";

class GameDao implements GameDaoProtocol {
    
    private redis: RedisClientType;
    
    constructor(redis: RedisClientType) {
        this.redis = redis
    }

    async addPlayerMove(move: Move): Promise<Result<Moves>> {
        await this.redis.sAdd(move.player, move.position);
        const playerMoves: CellPosition[] = await this.redis.sMembers(move.player)
        return {
            type: "success",
            data: {
                player: move.player,
                positions: playerMoves
            }
        }
    }

    async getInfo(gameID: string): Promise<Result<GameInfo>> {
        const info = await this.redis.hmGet(gameID, ["currentPlayer", "gameState", "winner"]);
        const currentPlayer = info.currentPlayer;
        const gameState = info.gameState;
        const winner = info.winner
        return {
            type: "success",
            data: {
                currentPlayer: currentPlayer,
                gameState: gameState,
                winner: winner
            }
        }
    }

    async getPlayerMoves(move: Move): Promise<Result<Moves>> {
        const playerMoves: CellPosition[] = await this.redis.sMembers(move.player)
        return {
            type: "success",
            data: {
                player: move.player,
                positions: playerMoves
            }
        }
    }

    async updateInfo(gameID: string, info: GameInfo): Promise<Result<GameInfo>> {
        await this.redis.hSet(gameID, {
            currentPlayer: info.currentPlayer,
            gameState: info.gameState,
            winner: info.winner
        })

        return {type: "success", data: {currentPlayer: info.currentPlayer, gameState: info.gameState, winner: info.winner}}

    }

}

interface GameDaoProtocol {
    addPlayerMove(move: Move): Promise<Result<Moves>>
    getPlayerMoves(move: Move): Promise<Result<Moves>>
    getInfo(gameID: string): Promise<Result<GameInfo>>
    updateInfo(gameID: string, info: GameInfo): Promise<Result<GameInfo>>
}

export {GameDao}