import {GameRepository} from "../../repository/GameRepository";
import {BoardType} from "../../../model/BoardType";

class GameRepositoryImpl implements GameRepository {
    
    private client: RedisData;
    
    constructor(client: RedisData) {
        this.client = client;
    }
    
    async createNewGame(): Promise<Result<GameType>> {
        const newGame = await this.client.gameDao.setGame()
    }
    
    async resetGame(): Promise<Result<GameType>> {
        const newGame = await this.client.gameDao.resetGame()
    }
    
    async updateBoard(row: number, col: number, player: PlayerType): Promise<Result<GameType>> {
        const newBoard = await this.client.gameDao.addPlayerMove()
    }
    
    async switchCurrentPlayer(): Promise<Result<GameType>> {
        
    }
    
    async getCurrentPlayer(gameID: string): Promise<Result<PlayerType>> {
        const info = await this.client.gameDao.getInfo(gameID)
    }
    
    async getBoardState(): Promise<Result<BoardType>> {
        const boardState = await this.client.gameDao.getPlayerMoves()
    }
    
}