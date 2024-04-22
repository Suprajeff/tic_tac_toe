import {GameRepository} from "../../repository/GameRepository";
import {BoardType} from "../../../model/BoardType";
import { PlayerType } from "../../../model/PlayerType";
import { GameType } from "../../../model/GameType";
import { Result } from "../../../common/result/Result";
import { CellPosition } from "../../../model/CellPosition";

class GameRepositoryImpl implements GameRepository {
    
    private client: RedisData;
    
    constructor(client: RedisData) {
        this.client = client;
    }
    
    async createNewGame(newKey: string, board: BoardType, player: PlayerType): Promise<Result<GameType>> {
        const newGame = await this.client.gameDao.setGame(newKey, board, player)
    }
    
    async resetGame(gameID: string, board: BoardType, player: PlayerType): Promise<Result<GameType>> {
        const newGame = await this.client.gameDao.resetGame(gameID, board, player)
    }
    
    async updateBoard(gameID: string, position: CellPosition, player: PlayerType): Promise<Result<GameType>> {
        const newBoard = await this.client.gameDao.addPlayerMove(gameID, {player, position})
    }
    
    async switchCurrentPlayer(gameID: string): Promise<Result<GameType>> {
        
    }
    
    async getCurrentPlayer(gameID: string): Promise<Result<PlayerType>> {
        const info = await this.client.gameDao.getInfo(gameID)
    }
    
    async getBoardState(gameID: string): Promise<Result<BoardType>> {
        const boardState = await this.client.gameDao.getPlayerMoves()
    }
    
    async getGameState(gameID: string): Promise<Result<GameType>> {

    }

}