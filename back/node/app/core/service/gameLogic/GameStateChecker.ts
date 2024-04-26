import { Result, notFound, success } from "../../common/result/Result";
import { CellPosition } from "../../model/CellPosition";
import { CellType } from "../../model/CellType";
import {GameResult} from "../../model/GameResult";
import { winningCombinationsForArray, winningCombinationsForDictionary } from "./WinningCombinations";

interface GameStateCheckerB {
    checkForVictoryOrDrawA(cells: CellType[][]): Result<GameResult>;
    checkForVictoryOrDrawB(cells: Record<CellPosition, CellType>): Result<GameResult>;
    checkForVictoryOrDrawC(playersMoves: Record<NonNullable<CellType>, CellPosition[]>): Result<GameResult>;
}

class GameStateChecker implements GameStateCheckerB {

    checkForVictoryOrDrawA(cells: CellType[][]): Result<GameResult> {

        for (const [a, b, c] of winningCombinationsForArray) {
            const cell1 = cells[Math.floor(a / 3)][a % 3];
            const cell2 = cells[Math.floor(b / 3)][b % 3];
            const cell3 = cells[Math.floor(c / 3)][c % 3];

            if (cell1 !== null && cell1 === cell2 && cell2 === cell3) {
            return success({winner: {symbol: cell1}, draw: false});
            }
        }

        const cellAvailable= cells.some(row => row.some(cell => cell === null));
        return cellAvailable ? notFound : success({ winner: null, draw: true });

    }

    checkForVictoryOrDrawB(cells: Record<CellPosition, CellType>): Result<GameResult> {

        for (const combination of winningCombinationsForDictionary) {
            const [pos1, pos2, pos3] = combination;
            const cell1 = cells[pos1];
            const cell2 = cells[pos2];
            const cell3 = cells[pos3];

            if (cell1 && cell1 === cell2 && cell2 === cell3) {
                return success({winner: {symbol: cell1}, draw: false});
            }
        }

        const cellAvailable = Object.values(cells).some(cell => cell === null)
        return cellAvailable ? notFound : success({ winner: null, draw: true });

    }

    checkForVictoryOrDrawC(playersMoves: Record<NonNullable<CellType>, CellPosition[]>): Result<GameResult> {

        const playersSymbols: NonNullable<CellType>[] = ['X', 'O']

        const winningPlayer = playersSymbols.find(player  => {
            const moves = playersMoves[player];
            return winningCombinationsForDictionary.some(combination => {
                return combination.every(pos => moves.includes(pos));
            });
        });

        if(winningPlayer) {return  success({winner: {symbol: winningPlayer}, draw: false})}
        const cellAvailable = 9 - (playersMoves.X.length + playersMoves.O.length);
        return cellAvailable ? notFound : success({ winner: null, draw: true });

    }

}

export {GameStateCheckerB, GameStateChecker}
