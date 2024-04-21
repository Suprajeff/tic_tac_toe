import {GameRepository} from "../../repository/GameRepository";

class GameRepositoryImpl implements GameRepository {
    
    private client: RedisData;
    
    constructor(client: RedisData) {
        this.client = client;
    }
    
    async createNewGame(): Promise<Result<GameType>> {
        
    }
    
    async resetGame(): Promise<Result<GameType>> {
        
    }
    
    async updateBoard(row: number, col: number, player: PlayerType): Promise<Result<GameType>> {
        
    }
    
    async switchCurrentPlayer(): Promise<Result<GameType>> {
        
    }
    
    async getCurrentPlayer(): Promise<Result<PlayerType>> {
        
    }
    
    async getBoardState(): Promise<Result<BoardType>> {
        
    }
    
}