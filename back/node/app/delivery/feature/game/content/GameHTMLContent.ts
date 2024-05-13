import {GameTitle} from './types/GameTitle.js'
import {PlayerType} from "../../../../core/model/PlayerType.js";
import {StateType} from "../../../../core/model/StateType.js";
import {PlayersMoves} from "../../../../core/model/PlayersMoves.js";
import { CellPosition } from '../../../../core/model/CellPosition.js';
import { CellType } from '../../../../core/model/CellType.js';

class GameHTMLContent {

    private static readonly FILLED_CELL = `<div id="cell%s" class="flex items-center justify-center font-bold text-4xl bg-slate-600 text-white">%s</div>`;
    private static readonly EMPTY_CELL = `<div id="cell%s" class="flex items-center justify-center font-bold text-4xl bg-slate-900 text-white hover:bg-slate-600 transition-colors cursor-pointer" hx-post="http://localhost:8081/move" hx-request='{"credentials": "include"}' hx-trigger="click" hx-target="#board" hx-swap="outerHTML" hx-vals='{"position":"%s"}'></div>`;

    private static readonly NEW_GAME_BOARD = `
        <div id="board" class="flex flex-col gap-6 item-center justify-center" hx-trigger="load">
            <h1 id="gameTitle" class="text-slate-400 text-center text-4xl font-['Teachers']">Playing</h1>
            <div id="game" class="flex items-center justify-center">
                <div class="grid grid-cols-3 grid-rows-3 gap-4 bg-gray-200 p-4 rounded-lg h-64 w-64">
                    <div id="cellOne" class="flex items-center justify-center font-bold text-4xl bg-slate-900 text-white hover:bg-slate-600 transition-colors cursor-pointer" hx-post="http://localhost:8081/move" hx-request='{"credentials": "include"}' hx-trigger="click" hx-target="#board" hx-swap="outerHTML" hx-vals='{"position":"TL"}'></div>
                    <div id="cellTwo" class="flex items-center justify-center font-bold text-4xl bg-slate-900 text-white hover:bg-slate-600 transition-colors cursor-pointer" hx-post="http://localhost:8081/move" hx-request='{"credentials": "include"}' hx-trigger="click" hx-target="#board" hx-swap="outerHTML" hx-vals='{"position":"T"}'></div>
                    <div id="cellThree" class="flex items-center justify-center font-bold text-4xl bg-slate-900 text-white hover:bg-slate-600 transition-colors cursor-pointer" hx-post="http://localhost:8081/move" hx-request='{"credentials": "include"}' hx-trigger="click" hx-target="#board" hx-swap="outerHTML" hx-vals='{"position":"TR"}'></div>
                    <div id="cellFour" class="flex items-center justify-center font-bold text-4xl bg-slate-900 text-white hover:bg-slate-600 transition-colors cursor-pointer" hx-post="http://localhost:8081/move" hx-request='{"credentials": "include"}' hx-trigger="click" hx-target="#board" hx-swap="outerHTML" hx-vals='{"position":"L"}'></div>
                    <div id="cellFive" class="flex items-center justify-center font-bold text-4xl bg-slate-900 text-white hover:bg-slate-600 transition-colors cursor-pointer" hx-post="http://localhost:8081/move" hx-request='{"credentials": "include"}' hx-trigger="click" hx-target="#board" hx-swap="outerHTML" hx-vals='{"position":"C"}'></div>
                    <div id="cellSix" class="flex items-center justify-center font-bold text-4xl bg-slate-900 text-white hover:bg-slate-600 transition-colors cursor-pointer" hx-post="http://localhost:8081/move" hx-request='{"credentials": "include"}' hx-trigger="click" hx-target="#board" hx-swap="outerHTML" hx-vals='{"position":"R"}'></div>
                    <div id="cellSeven" class="flex items-center justify-center font-bold text-4xl bg-slate-900 text-white hover:bg-slate-600 transition-colors cursor-pointer" hx-post="http://localhost:8081/move" hx-request='{"credentials": "include"}' hx-trigger="click" hx-target="#board" hx-swap="outerHTML" hx-vals='{"position":"BL"}'></div>
                    <div id="cellEight" class="flex items-center justify-center font-bold text-4xl bg-slate-900 text-white hover:bg-slate-600 transition-colors cursor-pointer" hx-post="http://localhost:8081/move" hx-request='{"credentials": "include"}' hx-trigger="click" hx-target="#board" hx-swap="outerHTML" hx-vals='{"position":"B"}'></div>
                    <div id="cellNine" class="flex items-center justify-center font-bold text-4xl bg-slate-900 text-white hover:bg-slate-600 transition-colors cursor-pointer" hx-post="http://localhost:8081/move" hx-request='{"credentials": "include"}' hx-trigger="click" hx-target="#board" hx-swap="outerHTML" hx-vals='{"position":"BR"}'></div>
                </div>
            </div>
            <button class="bg-slate-400 hover:bg-slate-600 text-white font-bold py-2 px-4 rounded-full" hx-get="http://localhost:8081/restart" hx-trigger="click" hx-target="#board" hx-swap="outerHTML" hx-request='{"credentials": "include"}'>Reset</button>
        </div>
    `;

    private static readonly GAME_BOARD = `
        <div id="board" class="flex flex-col gap-6 item-center justify-center" hx-trigger="load">
            <h1 id="gameTitle" class="text-slate-400 text-center text-4xl font-['Teachers']">%s</h1>
            <div id="game" class="flex items-center justify-center">
                <div class="grid grid-cols-3 grid-rows-3 gap-4 bg-gray-200 p-4 rounded-lg h-64 w-64">
                    %s
                </div>
            </div>
            <button class="bg-slate-400 hover:bg-slate-600 text-white font-bold py-2 px-4 rounded-full" hx-get="http://localhost:8081/restart" hx-trigger="click" hx-target="#board" hx-swap="outerHTML" hx-request='{"credentials": "include"}'>Reset</button>
        </div>
    `;

    private static CELL: {id: string, position: CellPosition}[] = [
        {id: 'One', position: 'TL'},
        {id: 'Two', position: 'T'},
        {id: 'Three', position: 'TR'},
        {id: 'Four', position: 'L'},
        {id: 'Five', position: 'C'},
        {id: 'Six', position: 'R'},
        {id: 'Seven', position: 'BL'},
        {id: 'Eight', position: 'B'},
        {id: 'Nine', position: 'BR'},
    ]
    
    public static getFilledCellHTML(cellID: string, player: PlayerType): string {
        return GameHTMLContent.FILLED_CELL
        .replace('%s', cellID)
        .replace('%s', player.symbol);
    }

    public static getEmptyCellHTML(cellID: string, position: CellPosition): string {
        return GameHTMLContent.EMPTY_CELL
        .replace('%s', cellID)
        .replace('%s', position);
    }
    
    public static getNewBoard(): string {
        return GameHTMLContent.NEW_GAME_BOARD
    }

    public static getBoard(title: GameTitle, state: PlayersMoves): string {

        let boardContent = '';

        for(const cell of this.CELL){
            const playerX = state.X.includes(cell.position);
            const playerO = state.O.includes(cell.position);
            if (playerX || playerO) {
                const player: PlayerType = playerX ? { symbol: 'X' } : { symbol: 'O' };
                const filledCellHTML = GameHTMLContent.getFilledCellHTML(cell.id, player);
                boardContent += filledCellHTML;
            } else {
                const emptyCellHTML = GameHTMLContent.getEmptyCellHTML(cell.id, cell.position);
                boardContent += emptyCellHTML;
            }
        }

        return GameHTMLContent.GAME_BOARD.replace('%s', title).replace('%s', boardContent);

    }
    
}

export {GameHTMLContent}