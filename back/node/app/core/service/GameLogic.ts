import { Result } from "../common/result/Result";
import { PlayerType } from "../model/PlayerType";

interface GameLogicB {
    getNextPlayer(): Promise<Result<PlayerType>>;
    checkForWinner(): Promise<Result<PlayerType>>;
    checkForDraw(): Promise<Result<boolean>>;
}