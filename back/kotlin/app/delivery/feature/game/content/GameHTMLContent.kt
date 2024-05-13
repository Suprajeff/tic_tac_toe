class GameHTMLContent {
    
    private const val FILLED_CELL = """
        <div id="cell%s" class="flex items-center justify-center font-bold text-4xl bg-slate-600 text-white">%s</div>
    """

    private const val EMPTY_CELL = """
        <div id="cell%s" class="flex items-center justify-center font-bold text-4xl bg-slate-900 text-white hover:bg-slate-600 transition-colors cursor-pointer" hx-post="http://localhost:8082/move" hx-request='{"credentials": "include"}' hx-trigger="click" hx-target="#board" hx-swap="outerHTML" hx-vals='{"position":"%s"}'></div>
    """

    private const val NEW_GAME_BOARD = """
        <div id="board" class="flex flex-col gap-6 item-center justify-center" hx-trigger="load">
            <h1 id="gameTitle" class="text-slate-400 text-center text-4xl font-['Teachers']">Playing</h1>
            <div id="game" class="flex items-center justify-center">
                <div class="grid grid-cols-3 grid-rows-3 gap-4 bg-gray-200 p-4 rounded-lg h-64 w-64">
                    <div id="cellOne" class="flex items-center justify-center font-bold text-4xl bg-slate-900 text-white hover:bg-slate-600 transition-colors cursor-pointer" hx-post="http://localhost:8082/move" hx-request='{"credentials": "include"}' hx-trigger="click" hx-target="#board" hx-swap="outerHTML" hx-vals='{"position":"TL"}'></div>
                    <div id="cellTwo" class="flex items-center justify-center font-bold text-4xl bg-slate-900 text-white hover:bg-slate-600 transition-colors cursor-pointer" hx-post="http://localhost:8082/move" hx-request='{"credentials": "include"}' hx-trigger="click" hx-target="#board" hx-swap="outerHTML" hx-vals='{"position":"T"}'></div>
                    <div id="cellThree" class="flex items-center justify-center font-bold text-4xl bg-slate-900 text-white hover:bg-slate-600 transition-colors cursor-pointer" hx-post="http://localhost:8082/move" hx-request='{"credentials": "include"}' hx-trigger="click" hx-target="#board" hx-swap="outerHTML" hx-vals='{"position":"TR"}'></div>
                    <div id="cellFour" class="flex items-center justify-center font-bold text-4xl bg-slate-900 text-white hover:bg-slate-600 transition-colors cursor-pointer" hx-post="http://localhost:8082/move" hx-request='{"credentials": "include"}' hx-trigger="click" hx-target="#board" hx-swap="outerHTML" hx-vals='{"position":"L"}'></div>
                    <div id="cellFive" class="flex items-center justify-center font-bold text-4xl bg-slate-900 text-white hover:bg-slate-600 transition-colors cursor-pointer" hx-post="http://localhost:8082/move" hx-request='{"credentials": "include"}' hx-trigger="click" hx-target="#board" hx-swap="outerHTML" hx-vals='{"position":"C"}'></div>
                    <div id="cellSix" class="flex items-center justify-center font-bold text-4xl bg-slate-900 text-white hover:bg-slate-600 transition-colors cursor-pointer" hx-post="http://localhost:8082/move" hx-request='{"credentials": "include"}' hx-trigger="click" hx-target="#board" hx-swap="outerHTML" hx-vals='{"position":"R"}'></div>
                    <div id="cellSeven" class="flex items-center justify-center font-bold text-4xl bg-slate-900 text-white hover:bg-slate-600 transition-colors cursor-pointer" hx-post="http://localhost:8082/move" hx-request='{"credentials": "include"}' hx-trigger="click" hx-target="#board" hx-swap="outerHTML" hx-vals='{"position":"BL"}'></div>
                    <div id="cellEight" class="flex items-center justify-center font-bold text-4xl bg-slate-900 text-white hover:bg-slate-600 transition-colors cursor-pointer" hx-post="http://localhost:8082/move" hx-request='{"credentials": "include"}' hx-trigger="click" hx-target="#board" hx-swap="outerHTML" hx-vals='{"position":"B"}'></div>
                    <div id="cellNine" class="flex items-center justify-center font-bold text-4xl bg-slate-900 text-white hover:bg-slate-600 transition-colors cursor-pointer" hx-post="http://localhost:8082/move" hx-request='{"credentials": "include"}' hx-trigger="click" hx-target="#board" hx-swap="outerHTML" hx-vals='{"position":"BR"}'></div>
                </div>
            </div>
            <button class="bg-slate-400 hover:bg-slate-600 text-white font-bold py-2 px-4 rounded-full" hx-get="http://localhost:8082/restart" hx-trigger="click" hx-target="#board" hx-swap="outerHTML" hx-request='{"credentials": "include"}'>Reset</button>
        </div>
    """

    private const val GAME_BOARD = """
        <div id="board" class="flex flex-col gap-6 item-center justify-center" hx-trigger="load">
            <h1 id="gameTitle" class="text-slate-400 text-center text-4xl font-['Teachers']">%s</h1>
            <div id="game" class="flex items-center justify-center">
                <div class="grid grid-cols-3 grid-rows-3 gap-4 bg-gray-200 p-4 rounded-lg h-64 w-64">
                    %s
                </div>
            </div>
            <button class="bg-slate-400 hover:bg-slate-600 text-white font-bold py-2 px-4 rounded-full" hx-get="http://localhost:8082/restart" hx-trigger="click" hx-target="#board" hx-swap="outerHTML" hx-request='{"credentials": "include"}'>Reset</button>
        </div>
    """
    
    private val CELL = listOf(
        Cell(id = "One", position = CellPosition.TL),
        Cell(id = "Two", position = CellPosition.T),
        Cell(id = "Three", position = CellPosition.TR),
        Cell(id = "Four", position = CellPosition.L),
        Cell(id = "Five", position = CellPosition.C),
        Cell(id = "Six", position = CellPosition.R),
        Cell(id = "Seven", position = CellPosition.BL),
        Cell(id = "Eight", position = CellPosition.B),
        Cell(id = "Nine", position = CellPosition.BR)
    )

    fun getFilledCellHTML(cellID: String, player: PlayerType): String {
        return String.format(FILLED_CELL, cellID, player.symbol)
    }
    
    fun getEmptyCellHTML(cellID: String, position: CellPosition): String {
        return String.format(EMPTY_CELL, cellID, position)
    }
    
    fun getNewBoard(): String {
        return NEW_GAME_BOARD
    }

    fun getBoard(title: GameTitle, state: PlayersMoves): String {

        var boardContent = ""

        for (cell in CELL) {
            val playerX = state.X.contains(cell.position)
            val playerO = state.O.contains(cell.position)
            if (playerX || playerO) {
                val player = if (playerX) PlayerType("X") else PlayerType("O")
                val filledCellHTML = getFilledCellHTML(cell.id, player)
                boardContent += filledCellHTML
            } else {
                val emptyCellHTML = getEmptyCellHTML(cell.id, cell.position)
                boardContent += emptyCellHTML
            }
        }

        return String.format(GAME_BOARD, title, boardContent)
    }

}
