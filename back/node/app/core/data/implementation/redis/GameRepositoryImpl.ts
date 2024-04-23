import {GameRepository} from "../../repository/GameRepository";
import {BoardType} from "../../../model/BoardType";
import {PlayerType} from "../../../model/PlayerType";
import {GameType} from "../../../model/GameType";
import {Result, error, notFound, success} from "../../../common/result/Result";
import {CellPosition} from "../../../model/CellPosition";
import {RedisData} from "../../../database/redis/RedisData";

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
    
    async updateBoard(gameID: string, position: CellPosition, player: PlayerType): Promise<Result<GameType>> {
        const newBoard = await this.client.gameDao.addPlayerMove(gameID, {player, position})
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
    
    async getBoardState(gameID: string): Promise<Result<BoardType>> {
        const result = await this.client.gameDao.getInfo(gameID)
        switch (result.status) {
            case 'success':
                console.log('Data:', result.data);
                let boardData: BoardType = {}
                const xPositions = result.data.moves.X
                const oPositions = result.data.moves.O

                return success(boardData);
            case 'error':
                console.error('Error:', result.exception);
                return error(result.exception);
            case 'notFound':
                return notFound
        }
    }
    
    async getGameState(gameID: string): Promise<Result<GameType>> {
        const result = await this.client.gameDao.getInfo(gameID)
    }

}