import {RedisClientType} from "redis";
import { Move, Moves } from "../entity/Move.js";
import { GameInfo } from "../entity/GameInfo.js";
import {Result} from "../../../common/result/Result.js";
import {CellPosition} from "../../../model/CellPosition.js";
import {GameState} from "../../../model/GameState.js";
import {CellType} from "../../../model/CellType.js";
import {PlayerType} from "../../../model/PlayerType.js";
import {BoardType} from "../../../model/BoardType.js";
import {GameType} from "../../../model/GameType.js";
import {StateType} from "../../../model/StateType.js";

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
            status: "success",
            data: {
                id: newKey,
                currentPlayer: player,
                gameState: GameState.InProgress,
                state: board,
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
            status: "success",
            data: {
                id: gameID,
                currentPlayer: player,
                gameState: GameState.InProgress,
                state: board,
                winner: undefined
            }
        }

    }

    async addPlayerMove(gameID: string, move: Move): Promise<Result<StateType>> {
        console.log('New Move')
        console.log(move)
        await this.redis.sAdd(`${gameID}:moves:${move.player.symbol}`, move.position);
        const xMoves: CellPosition[] = await this.redis.sMembers(`${gameID}:moves:X`) as CellPosition[]
        const oMoves: CellPosition[] = await this.redis.sMembers(`${gameID}:moves:O`) as CellPosition[]
        console.log('xMoves')
        console.log(xMoves);
        console.log('oMoves')
        console.log(oMoves);
        return {
            status: "success",
            data: {X: xMoves, O: oMoves}
        }
    }

    async getInfo(gameID: string): Promise<Result<GameType>> {
        const info = await this.redis.hmGet(`${gameID}:info`, ["currentPlayer", "gameState", "winner"]);
        const currentPlayerSymbol = info[0] as NonNullable<CellType>;
        const gameState = info[1] as GameState;
        const winner = info[2] as NonNullable<CellType> | undefined;
        const playerWinner: PlayerType | undefined = winner ? {symbol: winner} : undefined
        const xMoves: CellPosition[] = await this.redis.sMembers(`${gameID}:moves:X`) as CellPosition[]
        const oMoves: CellPosition[] = await this.redis.sMembers(`${gameID}:moves:O`) as CellPosition[]
        return {
            status: "success",
            data: {
                id: gameID,
                currentPlayer: {symbol: currentPlayerSymbol},
                gameState: gameState,
                state: {X: xMoves, O: oMoves},
                winner: playerWinner
            }
        }
    }

    async getPlayerMoves(gameID: string, move: Move): Promise<Result<Moves>> {
        const playerMoves: CellPosition[] = await this.redis.sMembers(`${gameID}:moves:${move.player}`) as CellPosition[]
        return {
            status: "success",
            data: {
                player: move.player,
                positions: playerMoves
            }
        }
    }

    async updateInfo(gameID: string, board: StateType, info: GameInfo): Promise<Result<GameType>> {
        
        await this.redis.hSet(`${gameID}:info`, {
            currentPlayer: String(info.currentPlayer.symbol),
            gameState: String(info.gameState),
            winner: String(info.winner)
        })

        return {status: "success", data: {id: gameID, currentPlayer: info.currentPlayer, gameState: info.gameState, state: board, winner: info.winner}}

    }

}

interface GameDaoProtocol {
    setGame(newKey: string, board: BoardType, player: PlayerType): Promise<Result<GameType>>
    resetGame(gameID: string, board: BoardType, player: PlayerType): Promise<Result<GameType>>
    addPlayerMove(gameID: string,move: Move): Promise<Result<StateType>>
    getPlayerMoves(gameID: string, move: Move): Promise<Result<Moves>>
    getInfo(gameID: string): Promise<Result<GameType>>
    updateInfo(gameID: string, board: StateType, info: GameInfo): Promise<Result<GameType>>
}

export {GameDao}