import { Result } from "../common/result/Result";
import {GameType} from "../model/GameType";
import {PlayerType} from "../model/PlayerType";
import {GameRepository} from "../data/repository/GameRepository";

interface GameUseCasesB {
    initializeGame(): Promise<Result<GameType>>;
    getGame(): Promise<Result<GameType>>;
    makeMove(row: number, col: number, player: PlayerType): Promise<Result<GameType>>;
    getNextPlayer(): Promise<Result<PlayerType>>;
    checkForWinner(): Promise<Result<PlayerType>>;
    checkForDraw(): Promise<Result<boolean>>;
}

class GameUseCases implements GameUseCasesB {

    private gameRepo: GameRepository

    constructor(repository: GameRepository) {
        this.gameRepo = repository
    }

    async checkForDraw(): Promise<Result<boolean>> {
        return Promise.resolve(undefined);
    }

    async checkForWinner(): Promise<Result<PlayerType>> {
        return Promise.resolve(undefined);
    }

    async getGame(): Promise<Result<GameType>> {
        return Promise.resolve(undefined);
    }

    async getNextPlayer(): Promise<Result<PlayerType>> {
        return Promise.resolve(undefined);
    }

    async initializeGame(): Promise<Result<GameType>> {
        return Promise.resolve(undefined);
    }

    async makeMove(row: number, col: number, player: PlayerType): Promise<Result<GameType>> {
        return Promise.resolve(undefined);
    }

}