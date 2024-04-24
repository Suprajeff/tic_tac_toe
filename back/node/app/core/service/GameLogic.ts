import { Result } from "../common/result/Result";
import { PlayerType } from "../model/PlayerType";
import {BoardType} from "../model/BoardType";
import {StateType} from "../model/StateType";

interface GameLogicB {
    generateNewID(): Promise<Result<string>>;
    generateNewBoard(): Promise<Result<BoardType>>;
    randomPlayer(): Promise<Result<PlayerType>>;
    getNextPlayer(currentPlayer: PlayerType): Promise<Result<PlayerType>>;
    checkForWinner(boardState: StateType): Promise<Result<PlayerType>>;
    checkForDraw(boardState: StateType): Promise<Result<boolean>>;
}

class GameLogic implements GameLogicB {

    checkForDraw(boardState: StateType): Promise<Result<boolean>> {
        return Promise.resolve(undefined);
    }

    checkForWinner(boardState: StateType): Promise<Result<PlayerType>> {
        return Promise.resolve(undefined);
    }

    generateNewBoard(): Promise<Result<BoardType>> {
        return Promise.resolve(undefined);
    }

    generateNewID(): Promise<Result<string>> {
        return Promise.resolve(undefined);
    }

    getNextPlayer(currentPlayer: PlayerType): Promise<Result<PlayerType>> {
        return Promise.resolve(undefined);
    }

    randomPlayer(): Promise<Result<PlayerType>> {
        return Promise.resolve(undefined);
    }

}