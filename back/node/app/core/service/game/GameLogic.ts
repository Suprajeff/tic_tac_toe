import {Result, success, error, notFound} from "../../common/result/Result";
import { PlayerType } from "../../model/PlayerType";
import {BoardType} from "../../model/BoardType";
import {StateType} from "../../model/StateType";
import {randomUUID} from "crypto";
import { CellType } from "../../model/CellType";
import {GameResult} from "../../model/GameResult";
import {GameStateCheckerB} from "./GameStateChecker";

interface GameLogicB {
    generateNewID(): Result<string>;
    generateNewBoard(): BoardType;
    randomPlayer(): Result<PlayerType>;
    getNextPlayer(currentPlayer: PlayerType): Result<PlayerType>;
    checkForWinner(boardState: StateType): Result<GameResult>;
}

class GameLogic implements GameLogicB {

    private checker: GameStateCheckerB

    constructor(gameStateChecker: GameStateCheckerB) {
        this.checker = gameStateChecker
    }

    checkForWinner(boardState: StateType): Result<GameResult> {

        if ('cells' in boardState) {

            const cells = boardState.cells;

            if(Array.isArray(cells)){
                return this.checker.checkForVictoryOrDrawA(cells)
            } else {
                return this.checker.checkForVictoryOrDrawB(cells)
            }

        } else {
            return this.checker.checkForVictoryOrDrawC(boardState)
        }

    }

    generateNewBoard(): BoardType {
        return {
                cells: [
                    [null, null, null],
                    [null, null, null],
                    [null, null, null]
                ]
            };
    }

    generateNewID(): Result<string> {
        const newID: string = randomUUID()
        return newID ? success(newID) : error("could not generate a new ID")
    }

    getNextPlayer(currentPlayer: PlayerType): Result<PlayerType> {
        const nextPlayer: PlayerType = currentPlayer.symbol === 'X' ? {symbol: 'O'} : {symbol: 'X'}
        return nextPlayer ? success(nextPlayer) : error("could not get player")
    }

    randomPlayer(): Result<PlayerType> {
        const players: NonNullable<CellType>[] = ['X', 'O']
        const [symbol ] = players.sort(() => Math.random() - 0.5);
        return symbol ? success({symbol}) : error("could not get player");
    }

}

export {GameLogic}