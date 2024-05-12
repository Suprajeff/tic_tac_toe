import Foundation

class GameHTMLContent {
    
    private static let FILLED_CELL = """
        <div class="flex items-center justify-center font-bold text-4xl bg-slate-600 text-white">%s</div>
    """
    
    private static let NEW_GAME_BOARD = """
        <div id="board" class="flex flex-col gap-6 item-center justify-center">
            <h1 id="gameTitle" class="text-slate-400 text-center text-4xl font-['Teachers']">Playing</h1>
            <div id="game" class="flex items-center justify-center">
                <div class="grid grid-cols-3 grid-rows-3 gap-4 bg-gray-200 p-4 rounded-lg h-64 w-64">
                    <div id="cellOne" class="flex items-center justify-center font-bold text-4xl bg-slate-900 text-white hover:bg-slate-600 transition-colors cursor-pointer" hx-post="http://localhost:8081/move" hx-request='{"credentials": "include"}' hx-trigger="click" hx-swap="multi:#cellOne:outer,#gameTitle:inner" hx-vals='{"position":"TL"}'></div>
                    <div id="cellTwo" class="flex items-center justify-center font-bold text-4xl bg-slate-900 text-white hover:bg-slate-600 transition-colors cursor-pointer" hx-post="http://localhost:8081/move" hx-request='{"credentials": "include"}' hx-trigger="click" hx-swap="multi:#cellTwo:outer,#gameTitle:inner" hx-vals='{"position":"T"}'></div>
                    <div id="cellThree" class="flex items-center justify-center font-bold text-4xl bg-slate-900 text-white hover:bg-slate-600 transition-colors cursor-pointer" hx-post="http://localhost:8081/move" hx-request='{"credentials": "include"}' hx-trigger="click" hx-swap="multi:#cellThree:outer,#gameTitle:inner" hx-vals='{"position":"TR"}'></div>
                    <div id="cellFour" class="flex items-center justify-center font-bold text-4xl bg-slate-900 text-white hover:bg-slate-600 transition-colors cursor-pointer" hx-post="http://localhost:8081/move" hx-request='{"credentials": "include"}' hx-trigger="click" hx-swap="multi:#cellFour:outer,#gameTitle:inner" hx-vals='{"position":"L"}'></div>
                    <div id="cellFive" class="flex items-center justify-center font-bold text-4xl bg-slate-900 text-white hover:bg-slate-600 transition-colors cursor-pointer" hx-post="http://localhost:8081/move" hx-request='{"credentials": "include"}' hx-trigger="click" hx-swap="multi:#cellFive:outer,#gameTitle:inner" hx-vals='{"position":"C"}'></div>
                    <div id="cellSix" class="flex items-center justify-center font-bold text-4xl bg-slate-900 text-white hover:bg-slate-600 transition-colors cursor-pointer" hx-post="http://localhost:8081/move" hx-request='{"credentials": "include"}' hx-trigger="click" hx-swap="multi:#cellSix:outer,#gameTitle:inner" hx-vals='{"position":"R"}'></div>
                    <div id="cellSeven" class="flex items-center justify-center font-bold text-4xl bg-slate-900 text-white hover:bg-slate-600 transition-colors cursor-pointer" hx-post="http://localhost:8081/move" hx-request='{"credentials": "include"}' hx-trigger="click" hx-swap="multi:#cellSeven:outer,#gameTitle:inner" hx-vals='{"position":"BL"}'></div>
                    <div id="cellEight" class="flex items-center justify-center font-bold text-4xl bg-slate-900 text-white hover:bg-slate-600 transition-colors cursor-pointer" hx-post="http://localhost:8081/move" hx-request='{"credentials": "include"}' hx-trigger="click" hx-swap="multi:#cellEight:outer,#gameTitle:inner" hx-vals='{"position":"B"}'></div>
                    <div id="cellNine" class="flex items-center justify-center font-bold text-4xl bg-slate-900 text-white hover:bg-slate-600 transition-colors cursor-pointer" hx-post="http://localhost:8081/move" hx-request='{"credentials": "include"}' hx-trigger="click" hx-swap="multi:#cellNine:outer,#gameTitle:inner" hx-vals='{"position":"BR"}'></div>
                </div>
            </div>
            <button class="bg-slate-400 hover:bg-slate-600 text-white font-bold py-2 px-4 rounded-full" hx-get="http://localhost:8081/restart" hx-trigger="click" hx-target="#board" hx-swap="outerHTML" hx-request='{"credentials": "include"}'>Reset</button>
        </div>
    """
    
    private static let GAME_TITLE = """
        <h1 id="gameTitle" class="text-slate-400 text-center text-4xl font-['Teachers']">%s</h1>
    """
    
    static func getFilledCellHTML(player: PlayerType) -> String {
        return String(format: FILLED_CELL, player.symbol)
    }
    
    static func getGameTitleHTML(title: GameTitle) -> String {
        return String(format: GAME_TITLE, title)
    }
    
    static func getNewBoard() -> String {
        return NEW_GAME_BOARD
    }
}
