package service

import "go-ttt/app/core/model"

var WinningCombinationsForDictionary = [][]model.CellPosition{
	{model.TL, model.T, model.TR}, // Rows
	{model.L, model.C, model.R},
	{model.BL, model.B, model.BR},
	{model.TL, model.L, model.BL}, // Columns
	{model.T, model.C, model.B},
	{model.TR, model.R, model.BR},
	{model.TL, model.C, model.BR}, // Diagonals
	{model.TR, model.C, model.BL},
}

var WinningCombinationsForArray = [][]int{
	{0, 1, 2}, // Row 1
	{3, 4, 5}, // Row 2
	{6, 7, 8}, // Row 3
	{0, 3, 6}, // Column 1
	{1, 4, 7}, // Column 2
	{2, 5, 8}, // Column 3
	{0, 4, 8}, // Diagonal 1
	{2, 4, 6}, // Diagonal 2
}
