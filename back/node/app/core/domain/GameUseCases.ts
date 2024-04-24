import { Result } from "../common/result/Result";
import {GameType} from "../model/GameType";
import {PlayerType} from "../model/PlayerType";
import {GameRepository} from "../data/repository/GameRepository";
import {BoardType} from "../model/BoardType";
import {CellPosition} from "../model/CellPosition";

interface GameUseCasesB {
    initializeGame(newKey: string, board: BoardType, player: PlayerType): Promise<Result<GameType>>;
    resetGame(gameID: string, board: BoardType, player: PlayerType): Promise<Result<GameType>>;
    makeMove(gameID: string, position: CellPosition, player: PlayerType): Promise<Result<GameType>>;
}

class GameUseCases implements GameUseCasesB {

    private gameRepo: GameRepository


    constructor(repository: GameRepository) {
        this.gameRepo = repository
    }

    async initializeGame(newKey: string, board: BoardType, player: PlayerType): Promise<Result<GameType>> {
        // Service to generate new key
        // Service to initialize new board
        // Service to randomly choose which player starts the game
        return  await this.gameRepo.createNewGame(newKey, board, player)
    }

    async resetGame(gameID: string, board: BoardType, player: PlayerType): Promise<Result<GameType>> {
        // Service to initialize new board
        // Service to randomly choose which player starts the game
        return  await this.gameRepo.resetGame(gameID, board, player)
    }

    async makeMove(gameID: string, position: CellPosition, player: PlayerType): Promise<Result<GameType>> {
        const newBoardState = await this.gameRepo.updateBoard(gameID, position, player)
        // Service to check winner
        // Service to check draw
        // Service to switch player
    }

}