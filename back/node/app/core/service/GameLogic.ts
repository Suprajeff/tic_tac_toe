import { Result } from "../common/result/Result";
import { PlayerType } from "../model/PlayerType";
import {BoardType} from "../model/BoardType";

interface GameLogicB {
    generateNewID(): Promise<Result<string>>;
    generateNewBoard(): Promise<Result<BoardType>>;
    randomPlayer(): Promise<Result<PlayerType>>;
    getNextPlayer(): Promise<Result<PlayerType>>;
    checkForWinner(): Promise<Result<PlayerType>>;
    checkForDraw(): Promise<Result<boolean>>;
}