import {Result, success, error, notFound} from "../../common/result/Result";
import { PlayerType } from "../../model/PlayerType";
import {BoardType} from "../../model/BoardType";
import {StateType} from "../../model/StateType";
import {randomUUID} from "crypto";
import { CellPosition } from "../../model/CellPosition";
import { CellType } from "../../model/CellType";

interface GameLogicB {
    generateNewID(): Result<string>;
    generateNewBoard(): BoardType;
    randomPlayer(): Result<PlayerType>;
    getNextPlayer(currentPlayer: PlayerType): Result<PlayerType>;
    checkForWinner(boardState: StateType): Result<PlayerType>;
}

class GameLogic implements GameLogicB {

    checkForWinner(boardState: StateType): Result<PlayerType> {

        const winningCombinations: CellPosition[][] = [
            ['TL', 'T', 'TR'], ['L', 'C', 'R'], ['BL', 'B', 'BR'], // Rows
            ['TL', 'L', 'BL'], ['T', 'C', 'B'], ['TR', 'R', 'BR'], // Columns
            ['TL', 'C', 'BR'], ['TR', 'C', 'BL'] // Diagonals
        ];

        const winningCombinationsArray: [number, number, number][] = [
            [0, 1, 2], // Row 1
            [3, 4, 5], // Row 2
            [6, 7, 8], // Row 3
            [0, 3, 6], // Column 1
            [1, 4, 7], // Column 2
            [2, 5, 8], // Column 3
            [0, 4, 8], // Diagonal 1
            [2, 4, 6]  // Diagonal 2
        ];


        if ('cells' in boardState) {

            const cells = boardState.cells;

            if(Array.isArray(cells)){

                for (const [a, b, c] of winningCombinationsArray) {
                    const cell1 = cells[Math.floor(a / 3)][a % 3];
                    const cell2 = cells[Math.floor(b / 3)][b % 3];
                    const cell3 = cells[Math.floor(c / 3)][c % 3];

                    if (cell1 !== null && cell1 === cell2 && cell2 === cell3) {
                    return success({symbol: cell1});
                    }
                }

                return notFound;

            } else {

                for (const combination of winningCombinations) {
                    const [pos1, pos2, pos3] = combination;
                    const cell1 = cells[pos1];
                    const cell2 = cells[pos2];
                    const cell3 = cells[pos3];

                    if (cell1 && cell1 === cell2 && cell2 === cell3) {
                        return success({symbol: cell1});
                    }
                }

                return notFound

            }

        } else {

            const playersMoves = boardState;
            const playersSymbols: NonNullable<CellType>[] = ['X', 'O']

            const winningPlayer = playersSymbols.find(player  => {
                const moves = playersMoves[player];
                return winningCombinations.some(combination => {
                    return combination.every(pos => moves.includes(pos));
                });
            });

            return winningPlayer ? success({symbol: winningPlayer}) : notFound

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