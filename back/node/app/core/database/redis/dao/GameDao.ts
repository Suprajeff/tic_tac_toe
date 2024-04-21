import {RedisClientType} from "redis";
import { Move, Moves } from "../entity/Move";
import { GameInfo } from "../entity/GameInfo";
import {Result} from "../../../common/result/Result";
import {CellPosition} from "../../../model/CellPosition";
import {GameState} from "../../../model/GameState";
import {CellType} from "../../../model/CellType";
import {PlayerType} from "../../../model/PlayerType";
import {BoardType} from "../../../model/BoardType";
import {GameType} from "../../../model/GameType";

class GameDao implements GameDaoProtocol {
    
    private redis: RedisClientType;
    
    constructor(redis: RedisClientType) {
        this.redis = redis
    }

    async setGame(newKey: string, board: BoardType, player: PlayerType): Promise<Result<GameType>> {

        const newGame = await this.redis.hSet(`${newKey}:info`, {
            currentPlayer: player.symbol, // "X"
            gameState: "IN_PROGRESS"
        })

        return {
            type: "success",
            data: {
                id: newKey,
                board: board,
                currentPlayer: player,
                gameState: GameState.InProgress,
                winner: undefined
            }
        }

    }

    async resetGame(gameID: string, board: BoardType, player: PlayerType): Promise<Result<GameType>> {

        await this.redis.del([`${gameID}:moves:X`, `${gameID}:moves:O`]);
        await this.redis.hDel(`${gameID}:info`, "winner");

        const newGame = await this.redis.hSet(`${gameID}:info`, {
            currentPlayer: player.symbol, // "X"
            gameState: "IN_PROGRESS"
        })

        return {
            type: "success",
            data: {
                id: gameID,
                board: board,
                currentPlayer: player,
                gameState: GameState.InProgress,
                winner: undefined
            }
        }

    }

    async addPlayerMove(gameID: string, move: Move): Promise<Result<Moves>> {
        await this.redis.sAdd(`${gameID}:moves:${move.player}`, move.position);
        const playerMoves: CellPosition[] = await this.redis.sMembers(`${gameID}:moves:${move.player}`) as CellPosition[]
        return {
            type: "success",
            data: {
                player: move.player,
                positions: playerMoves
            }
        }
    }

    async getInfo(gameID: string): Promise<Result<GameInfo>> {
        const info = await this.redis.hmGet(`${gameID}:info`, ["currentPlayer", "gameState", "winner"]);
        const currentPlayerSymbol = info[0] as NonNullable<CellType>;
        const gameState = info[1] as GameState;
        const winner = info[2] as CellType;
        return {
            type: "success",
            data: {
                currentPlayer: {symbol: currentPlayerSymbol},
                gameState: gameState,
                winner: winner
            }
        }
    }

    async getPlayerMoves(gameID: string, move: Move): Promise<Result<Moves>> {
        const playerMoves: CellPosition[] = await this.redis.sMembers(`${gameID}:moves:${move.player}`) as CellPosition[]
        return {
            type: "success",
            data: {
                player: move.player,
                positions: playerMoves
            }
        }
    }

    async updateInfo(gameID: string, info: GameInfo): Promise<Result<GameInfo>> {
        await this.redis.hSet(`${gameID}:info`, {
            currentPlayer: String(info.currentPlayer.symbol),
            gameState: String(info.gameState),
            winner: String(info.winner)
        })

        return {type: "success", data: {currentPlayer: info.currentPlayer, gameState: info.gameState, winner: info.winner}}

    }

}

interface GameDaoProtocol {
    setGame(newKey: string, board: BoardType, player: PlayerType): Promise<Result<GameType>>
    resetGame(gameID: string, board: BoardType, player: PlayerType): Promise<Result<GameType>>
    addPlayerMove(gameID: string,move: Move): Promise<Result<Moves>>
    getPlayerMoves(gameID: string, move: Move): Promise<Result<Moves>>
    getInfo(gameID: string): Promise<Result<GameInfo>>
    updateInfo(gameID: string, info: GameInfo): Promise<Result<GameInfo>>
}

export {GameDao}