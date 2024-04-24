import {Result, success, error} from "../common/result/Result";
import { PlayerType } from "../model/PlayerType";
import {BoardType} from "../model/BoardType";
import {StateType} from "../model/StateType";
import {randomUUID} from "crypto";

interface GameLogicB {
    generateNewID(): Result<string>;
    generateNewBoard(): BoardType;
    randomPlayer(): Result<PlayerType>;
    getNextPlayer(currentPlayer: PlayerType): Result<PlayerType>;
    checkForWinner(boardState: StateType): Result<boolean, PlayerType?>;
}

class GameLogic implements GameLogicB {

    checkForWinner(boardState: StateType): Result<boolean, PlayerType?> {

        const winningCombinations: CellPosition[][] = [
            ['TL', 'T', 'TR'], ['L', 'C', 'R'], ['BL', 'B', 'BR'], // Rows
            ['TL', 'L', 'BL'], ['T', 'C', 'B'], ['TR', 'R', 'BR'], // Columns
            ['TL', 'C', 'BR'], ['TR', 'C', 'BL'] // Diagonals
        ];

        if ('cells' in boardState) {

            const cells = boardState.cells;

            for (const combination of winningCombinations) {
                const [pos1, pos2, pos3] = combination;
                const cell1 = cells[pos1];
                const cell2 = cells[pos2];
                const cell3 = cells[pos3];

                if (cell1 && cell1 === cell2 && cell2 === cell3) {
                    return success(true, cell1);
                }
            }

            return success(false, null)

        } else {

            const playersMoves = boardState;

            const winningPlayer = ['X', 'O'].find(player => {
                const moves = playersMoves[player as CellType];
                return winningCombinations.some(combination => {
                    return combination.every(pos => moves.includes(pos));
                });
            });

            return winningPlayer ? success(true, winningPlayer) : success(false, null)

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
        const [symbol] = ['X', 'O'].sort(() => Math.random() - 0.5);
        return symbol ? success({ symbol }) : error("could not get player");
    }

}