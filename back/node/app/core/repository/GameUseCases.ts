import { Result } from "../common/result/Result";
import {GameType} from "../model/GameType";
import {PlayerType} from "../model/PlayerType";

interface GameUseCases {
    initializeGame(): Promise<Result<GameType>>;
    getGame(): Promise<Result<GameType>>;
    makeMove(row: number, col: number): Promise<Result<GameType>>;
    getNextPlayer(): Promise<Result<PlayerType>>;
    checkForWinner(): Promise<Result<PlayerType>>;
    checkForDraw(): Promise<Result<boolean>>;
}