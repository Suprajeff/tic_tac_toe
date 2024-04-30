import { CellPosition } from "../../model/CellPosition.js";

const winningCombinationsForDictionary: CellPosition[][] = [
    ['TL', 'T', 'TR'], ['L', 'C', 'R'], ['BL', 'B', 'BR'], // Rows
    ['TL', 'L', 'BL'], ['T', 'C', 'B'], ['TR', 'R', 'BR'], // Columns
    ['TL', 'C', 'BR'], ['TR', 'C', 'BL'] // Diagonals
];

const winningCombinationsForArray: [number, number, number][] = [
    [0, 1, 2], // Row 1
    [3, 4, 5], // Row 2
    [6, 7, 8], // Row 3
    [0, 3, 6], // Column 1
    [1, 4, 7], // Column 2
    [2, 5, 8], // Column 3
    [0, 4, 8], // Diagonal 1
    [2, 4, 6]  // Diagonal 2
];

export { winningCombinationsForDictionary, winningCombinationsForArray}