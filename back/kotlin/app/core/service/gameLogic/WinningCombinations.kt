val winningCombinationsForDictionary = listOf(
    Triple(CellPosition.TL, CellPosition.T, CellPosition.TR), // Rows
    Triple(CellPosition.L, CellPosition.C, CellPosition.R),
    Triple(CellPosition.BL, CellPosition.B, CellPosition.BR),
    Triple(CellPosition.TL, CellPosition.L, CellPosition.BL), // Columns
    Triple(CellPosition.T, CellPosition.C, CellPosition.B),
    Triple(CellPosition.TR, CellPosition.R, CellPosition.BR),
    Triple(CellPosition.TL, CellPosition.C, CellPosition.BR), // Diagonals
    Triple(CellPosition.TR, CellPosition.C, CellPosition.BL)
)

val winningCombinationsForArray = listOf(
    Triple(0, 1, 2), // Row 1
    Triple(3, 4, 5), // Row 2
    Triple(6, 7, 8), // Row 3
    Triple(0, 3, 6), // Column 1
    Triple(1, 4, 7), // Column 2
    Triple(2, 5, 8), // Column 3
    Triple(0, 4, 8), // Diagonal 1
    Triple(2, 4, 6)  // Diagonal 2
)