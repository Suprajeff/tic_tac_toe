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

    public static func getFilledCellHTML(cellID: String, player: PlayerType) -> Result<String, Error> {

        guard let playerSymbol = TypeConverter.playerTypeToString(player) else {
            return .failure(CustomError("Failed to extract or convert data"))
        }
        let formattedString = String(format: FILLED_CELL, cellID, playerSymbol)
        return .success(formattedString)

    }

    public static func getEmptyCellHTML(cellID: String, position: CellPosition) -> Result<String, Error> {

        guard let cellPosition = TypeConverter.cellPositiontoString(position) else {
            return .failure(CustomError("Failed to extract or convert data"))
        }
        let formattedString = String(format: EMPTY_CELL, cellID, cellPosition)
        return .success(formattedString)

    }
    
    public static func getNewBoard() -> String {
        return NEW_GAME_BOARD
    }

    static func getBoard(title: GameTitle, state: PlayersMoves) -> Result<String, Error> {

        var boardContent = ""

        for cell in CELL {
            let playerX = state[.X]?.contains(cell.position) ?? false
            let playerO = state[.O]?.contains(cell.position) ?? false

            if playerX || playerO {
                let playerSymbol: CellType = playerX ? .X : .O
                let filledCellResult = getFilledCellHTML(cellID: cell.id, player: PlayerType(symbol: playerSymbol))
                switch filledCellResult {
                    case .success(let filledCellHTML):
                        boardContent += filledCellHTML
                    case .failure(let error):
                        print("Error: \(error.localizedDescription)")
                        boardContent += "<div>Error in generating filled cell HTML</div>"
                    case .notFound:
                        boardContent += "<div>Error finding info</div>"
                }
            } else {
                let emptyCellResult = getEmptyCellHTML(cellID: cell.id, position: cell.position)
                switch emptyCellResult {
                    case .success(let emptyCellHTML):
                        boardContent += emptyCellHTML
                    case .failure(let error):
                        print("Error: \(error.localizedDescription)")
                        boardContent += "<div>Error in generating empty cell HTML</div>"
                    case .notFound:
                        boardContent += "<div>Error finding info</div>"
                }
            }
        }

        return .success(String(format: GAME_BOARD, title.rawValue, boardContent))

    }

}
