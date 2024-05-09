import {Request, Response} from "express";
import {GameUseCasesB} from "../../../../core/domain/GameUseCases.js";
import {GameResponses} from "../../../utils/responses/SResponses.js";
import {CellPosition} from "../../../../core/model/CellPosition.js";
import {PlayerType} from "../../../../core/model/PlayerType.js";
import {Result} from "../../../../core/common/result/Result.js";
import {GameType} from "../../../../core/model/GameType.js";
import {GameHTMLContent} from "../content/GameHTMLContent.js";
import {GameTitle} from "../content/types/GameTitle.js";

class GameController {
    
    constructor(
        private useCases: GameUseCasesB,
        private sResponse: GameResponses
    ) {}
    
    async helloWorld(res: Response) {
        res.status(200).send("Hello, Node!");
    }
    
    async startGame(res: Response) {

        const result = await this.useCases.initializeGame()

        if (result.status === 'success') {

            const boardHtml = GameHTMLContent.getNewBoard();
            res.setHeader('Content-Type', 'text/html');
            res.status(200).send(boardHtml);

        } else {
            this.handleResult(result, res)
        }
    }
    
    async restartGame(req: Request, res: Response) {

        const { gameID } = req.body;
        const result = await this.useCases.resetGame(gameID)

        if (result.status === 'success') {

            const boardHtml = GameHTMLContent.getNewBoard();
            res.setHeader('Content-Type', 'text/html');
            console.log("board restarted")
            console.log(boardHtml)
            res.status(200).send(boardHtml);

        } else {
            this.handleResult(result, res)
        }
    }

    async makeMove(req: Request, res: Response) {

        console.log('===== body =====')
        console.log(req.body)
        console.log('===== body =====')

        const { gameID, positionData, playerData } = req.body;
        const position: CellPosition = JSON.parse(positionData);
        const player: PlayerType = JSON.parse(playerData);
        const result = await this.useCases.makeMove(gameID, position, player)

        if (result.status === 'success') {

            const newMove = GameHTMLContent.getFilledCellHTML(player);
            let newTitle: string = GameTitle.Playing

            if(result.data.gameState === 'WON' && result.data.winner) {
                newTitle = result.data.winner.symbol === 'X' ? GameHTMLContent.getGameTitleHTML(GameTitle.PlayerXWon) : GameHTMLContent.getGameTitleHTML(GameTitle.PlayerOWon)
            } else if (result.data.gameState === 'DRAW') {
                newTitle = GameHTMLContent.getGameTitleHTML(GameTitle.Draw)
            }

            const htmlMultiResponses = {
                "#cellOne": newMove,
                "#gameTitle": newTitle,
            }

            res.status(200).send(htmlMultiResponses);

        } else {
            this.handleResult(result, res)
        }
    }

    handleResult(result: Result<GameType>, res: Response) {
        switch (result.status) {
            case 'error':
                this.sResponse.serverErrR(res, null,500)
                break
            case 'notFound':
                this.sResponse.clientErrR(res, null,400)
                break
        }
    }

}

export {GameController}