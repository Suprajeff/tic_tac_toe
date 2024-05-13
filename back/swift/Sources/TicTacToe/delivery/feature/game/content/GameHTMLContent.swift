import Foundation

class GameHTMLContent {
    
    private static let FILLED_CELL = """
        <div id="cell%s" class="flex items-center justify-center font-bold text-4xl bg-slate-600 text-white">%s</div>
    """

    private static let EMPTY_CELL = """
        <div id="cell%s" class="flex items-center justify-center font-bold text-4xl bg-slate-900 text-white hover:bg-slate-600 transition-colors cursor-pointer" hx-post="http://localhost:8083/move" hx-request='{"credentials": "include"}' hx-trigger="click" hx-target="#board" hx-swap="outerHTML" hx-vals='{"position":"%s"}'></div>
    """

    private static let NEW_GAME_BOARD = """
        <div id="board" class="flex flex-col gap-6 item-center justify-center" hx-trigger="load">
            <h1 id="gameTitle" class="text-slate-400 text-center text-4xl font-['Teachers']">Playing</h1>
            <div id="game" class="flex items-center justify-center">
                <div class="grid grid-cols-3 grid-rows-3 gap-4 bg-gray-200 p-4 rounded-lg h-64 w-64">
                    <div id="cellOne" class="flex items-center justify-center font-bold text-4xl bg-slate-900 text-white hover:bg-slate-600 transition-colors cursor-pointer" hx-post="http://localhost:8083/move" hx-request='{"credentials": "include"}' hx-trigger="click" hx-target="#board" hx-swap="outerHTML" hx-vals='{"position":"TL"}'></div>
                    <div id="cellTwo" class="flex items-center justify-center font-bold text-4xl bg-slate-900 text-white hover:bg-slate-600 transition-colors cursor-pointer" hx-post="http://localhost:8083/move" hx-request='{"credentials": "include"}' hx-trigger="click" hx-target="#board" hx-swap="outerHTML" hx-vals='{"position":"T"}'></div>
                    <div id="cellThree" class="flex items-center justify-center font-bold text-4xl bg-slate-900 text-white hover:bg-slate-600 transition-colors cursor-pointer" hx-post="http://localhost:8083/move" hx-request='{"credentials": "include"}' hx-trigger="click" hx-target="#board" hx-swap="outerHTML" hx-vals='{"position":"TR"}'></div>
                    <div id="cellFour" class="flex items-center justify-center font-bold text-4xl bg-slate-900 text-white hover:bg-slate-600 transition-colors cursor-pointer" hx-post="http://localhost:8083/move" hx-request='{"credentials": "include"}' hx-trigger="click" hx-target="#board" hx-swap="outerHTML" hx-vals='{"position":"L"}'></div>
                    <div id="cellFive" class="flex items-center justify-center font-bold text-4xl bg-slate-900 text-white hover:bg-slate-600 transition-colors cursor-pointer" hx-post="http://localhost:8083/move" hx-request='{"credentials": "include"}' hx-trigger="click" hx-target="#board" hx-swap="outerHTML" hx-vals='{"position":"C"}'></div>
                    <div id="cellSix" class="flex items-center justify-center font-bold text-4xl bg-slate-900 text-white hover:bg-slate-600 transition-colors cursor-pointer" hx-post="http://localhost:8083/move" hx-request='{"credentials": "include"}' hx-trigger="click" hx-target="#board" hx-swap="outerHTML" hx-vals='{"position":"R"}'></div>
                    <div id="cellSeven" class="flex items-center justify-center font-bold text-4xl bg-slate-900 text-white hover:bg-slate-600 transition-colors cursor-pointer" hx-post="http://localhost:8083/move" hx-request='{"credentials": "include"}' hx-trigger="click" hx-target="#board" hx-swap="outerHTML" hx-vals='{"position":"BL"}'></div>
                    <div id="cellEight" class="flex items-center justify-center font-bold text-4xl bg-slate-900 text-white hover:bg-slate-600 transition-colors cursor-pointer" hx-post="http://localhost:8083/move" hx-request='{"credentials": "include"}' hx-trigger="click" hx-target="#board" hx-swap="outerHTML" hx-vals='{"position":"B"}'></div>
                    <div id="cellNine" class="flex items-center justify-center font-bold text-4xl bg-slate-900 text-white hover:bg-slate-600 transition-colors cursor-pointer" hx-post="http://localhost:8083/move" hx-request='{"credentials": "include"}' hx-trigger="click" hx-target="#board" hx-swap="outerHTML" hx-vals='{"position":"BR"}'></div>
                </div>
            </div>
            <button class="bg-slate-400 hover:bg-slate-600 text-white font-bold py-2 px-4 rounded-full" hx-get="http://localhost:8083/restart" hx-trigger="click" hx-target="#board" hx-swap="outerHTML" hx-request='{"credentials": "include"}'>Reset</button>
        </div>
    """
    
    private static let GAME_BOARD = """
        <div id="board" class="flex flex-col gap-6 item-center justify-center" hx-trigger="load">
            <h1 id="gameTitle" class="text-slate-400 text-center text-4xl font-['Teachers']">%s</h1>
            <div id="game" class="flex items-center justify-center">
                <div class="grid grid-cols-3 grid-rows-3 gap-4 bg-gray-200 p-4 rounded-lg h-64 w-64">
                    %s
                </div>
            </div>
            <button class="bg-slate-400 hover:bg-slate-600 text-white font-bold py-2 px-4 rounded-full" hx-get="http://localhost:8083/restart" hx-trigger="click" hx-target="#board" hx-swap="outerHTML" hx-request='{"credentials": "include"}'>Reset</button>
        </div>
    """
    
    private static let CELL: [(id: String, position: CellPosition)] = [
        (id: "One", position: .TL),
        (id: "Two", position: .T),
        (id: "Three", position: .TR),
        (id: "Four", position: .L),
        (id: "Five", position: .C),
        (id: "Six", position: .R),
        (id: "Seven", position: .BL),
        (id: "Eight", position: .B),
        (id: "Nine", position: .BR)
    ]

    public static func getFilledCellHTML(cellID: String, player: PlayerType) -> String {
        let formattedString = String(format: FILLED_CELL, cellID, player.symbol)
        return formattedString
    }
    
    public static func getEmptyCellHTML(cellID: String, position: CellPosition) -> String {
        let formattedString = String(format: EMPTY_CELL, cellID, position.rawValue)
        return formattedString
    }
    
    public static func getNewBoard() -> String {
        return NEW_GAME_BOARD
    }

    static func getBoard(title: GameTitle, state: PlayersMoves) -> String {
        var boardContent = ""

        for cell in CELL {
            let playerX = state.X.contains(cell.position)
            let playerO = state.O.contains(cell.position)

            if playerX || playerO {
                let playerSymbol = playerX ? "X" : "O"
                let filledCellHTML = getFilledCellHTML(cellID: cell.id, player: PlayerType(symbol: playerSymbol))
                boardContent += filledCellHTML
            } else {
                let emptyCellHTML = getEmptyCellHTML(cellID: cell.id, position: cell.position)
                boardContent += emptyCellHTML
            }
        }

        return String(format: GAME_BOARD, title, boardContent)
    }

}
