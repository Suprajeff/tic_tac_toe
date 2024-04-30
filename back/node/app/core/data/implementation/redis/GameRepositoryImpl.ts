import {GameRepository} from "../../repository/GameRepository.js";
import {BoardType} from "../../../model/BoardType.js";
import {PlayerType} from "../../../model/PlayerType.js";
import {GameType} from "../../../model/GameType.js";
import {Result, error, notFound, success} from "../../../common/result/Result.js";
import {CellPosition} from "../../../model/CellPosition.js";
import {RedisData} from "../../../database/redis/RedisData.js";
import {StateType} from "../../../model/StateType.js";
import { GameInfo } from "../../../database/redis/entity/GameInfo.js";

class GameRepositoryImpl implements GameRepository {
    
    private client: RedisData;
    
    constructor(client: RedisData) {
        this.client = client;
    }
    
    async createNewGame(newKey: string, board: BoardType, player: PlayerType): Promise<Result<GameType>> {
        return await this.client.gameDao.setGame(newKey, board, player);
    }
    
    async resetGame(gameID: string, board: BoardType, player: PlayerType): Promise<Result<GameType>> {
        return  await this.client.gameDao.resetGame(gameID, board, player)
    }
    
    async updateBoard(gameID: string, position: CellPosition, player: PlayerType): Promise<Result<StateType>> {
       return await this.client.gameDao.addPlayerMove(gameID, {player, position})
    }
    
    async getCurrentPlayer(gameID: string): Promise<Result<PlayerType>> {
        const result = await this.client.gameDao.getInfo(gameID)
        switch (result.status) {
            case 'success':
                console.log('Data:', result.data);
                return success({
                    symbol: result.data.currentPlayer.symbol
                });
            case 'error':
                console.error('Error:', result.exception);
                return error(result.exception);
            case 'notFound':
                return notFound
        }
    }
    
    async getBoardState(gameID: string): Promise<Result<StateType>> {
        const result = await this.client.gameDao.getInfo(gameID)
        switch (result.status) {
            case 'success':
                console.log('Data:', result.data);
                const boardState = result.data.state
                return success(boardState);
            case 'error':
                console.error('Error:', result.exception);
                return error(result.exception);
            case 'notFound':
                return notFound
        }
    }
    
    async getGameState(gameID: string): Promise<Result<GameType>> {
        return await this.client.gameDao.getInfo(gameID)
    }

    async updateGameState(gameID: string, board: StateType, gameInfo: GameInfo): Promise<Result<GameType>> {
        return await this.client.gameDao.updateInfo(gameID, board, gameInfo)
    }

}

export {GameRepositoryImpl}