import { Result } from "../common/result/Result";
import {GameType} from "../model/GameType";
import {PlayerType} from "../model/PlayerType";
import {GameRepository} from "../data/repository/GameRepository";

interface GameUseCasesB {
    initializeGame(): Promise<Result<GameType>>;
    resetGame(): Promise<Result<GameType>>;
    makeMove(row: number, col: number, player: PlayerType): Promise<Result<GameType>>;
}

class GameUseCases implements GameUseCasesB {

    private gameRepo: GameRepository

    constructor(repository: GameRepository) {
        this.gameRepo = repository
    }

    async initializeGame(): Promise<Result<GameType>> {
        return Promise.resolve(undefined);
    }

    async resetGame(): Promise<Result<GameType>> {
        return Promise.resolve(undefined);
    }

    async makeMove(row: number, col: number, player: PlayerType): Promise<Result<GameType>> {
        return Promise.resolve(undefined);
    }

}