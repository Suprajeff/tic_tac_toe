import {Result, success, error} from "../../common/result/Result";
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
    checkForWinner(boardState: StateType): Result<CellType>;
}

class GameLogic implements GameLogicB {

    checkForWinner(boardState: StateType): Result<CellType> {

        const winningCombinations: CellPosition[][] = [
            ['TL', 'T', 'TR'], ['L', 'C', 'R'], ['BL', 'B', 'BR'], // Rows
            ['TL', 'L', 'BL'], ['T', 'C', 'B'], ['TR', 'R', 'BR'], // Columns
            ['TL', 'C', 'BR'], ['TR', 'C', 'BL'] // Diagonals
        ];

        const cells = 'cells' in boardState
            ? boardState.cells
            : Object.fromEntries(Object.entries(boardState).flatMap(([player, moves]) => moves.map(pos => [pos, player])));

        for (const combination of winningCombinations) {
            const [pos1, pos2, pos3] = combination;
            const cell1 = cells[pos1];
            const cell2 = cells[pos2];
            const cell3 = cells[pos3];

            if (cell1 && cell1 === cell2 && cell2 === cell3) {
                return success(cell1);
            }
        }

        return success(null)

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