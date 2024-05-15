package content

import (
	"fmt"
	"go-ttt/app/core/model"
	service "go-ttt/app/core/service/game"
	"go-ttt/app/delivery/feature/game/content/types"
)

type Cell struct {
	ID       string
	Position model.CellPosition
}

const (
	
	FilledCell = `<div id="cell%s" class="flex items-center justify-center font-bold text-4xl bg-slate-600 text-white">%s</div>`

	EmptyCell = `<div id="cell%s" class="flex items-center justify-center font-bold text-4xl bg-slate-900 text-white hover:bg-slate-600 transition-colors cursor-pointer" hx-post="http://localhost:8080/move" hx-request='{"credentials": "include"}' hx-trigger="click" hx-target="#board" hx-swap="outerHTML" hx-vals='{"position":"%s"}'></div>`
	NewGameBoard = `<div id="board" class="flex flex-col gap-6 item-center justify-center" hx-trigger="load">
			<h1 id="gameTitle" class="text-slate-400 text-center text-4xl font-['Teachers']">Playing</h1>
			<div id="game" class="flex items-center justify-center">
				<div class="grid grid-cols-3 grid-rows-3 gap-4 bg-gray-200 p-4 rounded-lg h-64 w-64">
					<div id="cellOne" class="flex items-center justify-center font-bold text-4xl bg-slate-900 text-white hover:bg-slate-600 transition-colors cursor-pointer" hx-post="http://localhost:8080/move" hx-request='{"credentials": "include"}' hx-trigger="click" hx-target="#board" hx-swap="outerHTML" hx-vals='{"position":"TL"}'></div>
					<div id="cellTwo" class="flex items-center justify-center font-bold text-4xl bg-slate-900 text-white hover:bg-slate-600 transition-colors cursor-pointer" hx-post="http://localhost:8080/move" hx-request='{"credentials": "include"}' hx-trigger="click" hx-target="#board" hx-swap="outerHTML" hx-vals='{"position":"T"}'></div>
					<div id="cellThree" class="flex items-center justify-center font-bold text-4xl bg-slate-900 text-white hover:bg-slate-600 transition-colors cursor-pointer" hx-post="http://localhost:8080/move" hx-request='{"credentials": "include"}' hx-trigger="click" hx-target="#board" hx-swap="outerHTML" hx-vals='{"position":"TR"}'></div>
					<div id="cellFour" class="flex items-center justify-center font-bold text-4xl bg-slate-900 text-white hover:bg-slate-600 transition-colors cursor-pointer" hx-post="http://localhost:8080/move" hx-request='{"credentials": "include"}' hx-trigger="click" hx-target="#board" hx-swap="outerHTML" hx-vals='{"position":"L"}'></div>
					<div id="cellFive" class="flex items-center justify-center font-bold text-4xl bg-slate-900 text-white hover:bg-slate-600 transition-colors cursor-pointer" hx-post="http://localhost:8080/move" hx-request='{"credentials": "include"}' hx-trigger="click" hx-target="#board" hx-swap="outerHTML" hx-vals='{"position":"C"}'></div>
					<div id="cellSix" class="flex items-center justify-center font-bold text-4xl bg-slate-900 text-white hover:bg-slate-600 transition-colors cursor-pointer" hx-post="http://localhost:8080/move" hx-request='{"credentials": "include"}' hx-trigger="click" hx-target="#board" hx-swap="outerHTML" hx-vals='{"position":"R"}'></div>
					<div id="cellSeven" class="flex items-center justify-center font-bold text-4xl bg-slate-900 text-white hover:bg-slate-600 transition-colors cursor-pointer" hx-post="http://localhost:8080/move" hx-request='{"credentials": "include"}' hx-trigger="click" hx-target="#board" hx-swap="outerHTML" hx-vals='{"position":"BL"}'></div>
					<div id="cellEight" class="flex items-center justify-center font-bold text-4xl bg-slate-900 text-white hover:bg-slate-600 transition-colors cursor-pointer" hx-post="http://localhost:8080/move" hx-request='{"credentials": "include"}' hx-trigger="click" hx-target="#board" hx-swap="outerHTML" hx-vals='{"position":"B"}'></div>
					<div id="cellNine" class="flex items-center justify-center font-bold text-4xl bg-slate-900 text-white hover:bg-slate-600 transition-colors cursor-pointer" hx-post="http://localhost:8080/move" hx-request='{"credentials": "include"}' hx-trigger="click" hx-target="#board" hx-swap="outerHTML" hx-vals='{"position":"BR"}'></div>
				</div>
			</div>
			<button class="bg-slate-400 hover:bg-slate-600 text-white font-bold py-2 px-4 rounded-full" hx-get="http://localhost:8080/restart" hx-trigger="click" hx-target="#board" hx-swap="outerHTML" hx-request='{"credentials": "include"}'>Reset</button>
		</div>`
	
	GameBoard = `<div id="board" class="flex flex-col gap-6 item-center justify-center" hx-trigger="load">
			<h1 id="gameTitle" class="text-slate-400 text-center text-4xl font-['Teachers']">%s</h1>
			<div id="game" class="flex items-center justify-center">
				<div class="grid grid-cols-3 grid-rows-3 gap-4 bg-gray-200 p-4 rounded-lg h-64 w-64">
					%s
				</div>
			</div>
			<button class="bg-slate-400 hover:bg-slate-600 text-white font-bold py-2 px-4 rounded-full" hx-get="http://localhost:8080/restart" hx-trigger="click" hx-target="#board" hx-swap="outerHTML" hx-request='{"credentials": "include"}'>Reset</button>
		</div>`
	
)

var CELL = []Cell{
	{ID: "One", Position: model.TL},
	{ID: "Two", Position: model.T},
	{ID: "Three", Position: model.TR},
	{ID: "Four", Position: model.L},
	{ID: "Five", Position: model.C},
	{ID: "Six", Position: model.R},
	{ID: "Seven", Position: model.BL},
	{ID: "Eight", Position: model.B},
	{ID: "Nine", Position: model.BR},
}

func GetFilledCellHTML(cellID string, player model.PlayerType) string {
	return fmt.Sprintf(FilledCell, cellID, player.Symbol)
}

func GetEmptyCellHTML(cellID string, position model.CellPosition) string {
	return fmt.Sprintf(EmptyCell, cellID, position)
}

func GetNewBoard() string {
	return NewGameBoard
}

func GetBoard(title types.GameTitle, moves map[model.CellType][]model.CellPosition) string {

	var boardContent string

	for _, cell := range CELL {

		playerX := service.Contains(moves[model.X], cell.Position)
		playerO := service.Contains(moves[model.O], cell.Position)

		if playerX || playerO {
			var player model.PlayerType
			if playerX {
				player = model.PlayerType{Symbol: "X"}
			} else {
				player = model.PlayerType{Symbol: "O"}
			}
			filledCellHTML := GetFilledCellHTML(cell.ID, player)
			boardContent += filledCellHTML
		} else {
			emptyCellHTML := GetEmptyCellHTML(cell.ID, cell.Position)
			boardContent += emptyCellHTML
		}

	}

	return fmt.Sprintf(GameBoard, title, boardContent)

}