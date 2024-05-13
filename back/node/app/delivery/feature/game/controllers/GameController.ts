import {Request, Response} from "express";
import {GameUseCasesB} from "../../../../core/domain/GameUseCases.js";
import {GameResponses} from "../../../utils/responses/SResponses.js";
import {CellPosition} from "../../../../core/model/CellPosition.js";
import {Result} from "../../../../core/common/result/Result.js";
import {GameType} from "../../../../core/model/GameType.js";
import {GameHTMLContent} from "../content/GameHTMLContent.js";
import {GameTitle} from "../content/types/GameTitle.js";
import {PlayersMoves} from "../../../../core/model/PlayersMoves.js";

class GameController {
    
    constructor(
        private useCases: GameUseCasesB,
        private sResponse: GameResponses
    ) {}
    
    async helloWorld(res: Response) {
        res.status(200).send("Hello, Node!");
    }
    
    async startGame(req: Request, res: Response) {

        if(!req.session.gameID){

            const result = await this.useCases.initializeGame()

            console.log('Result Creation Log')
            console.log(result)

            if (result.status === 'success') {
                req.session.gameID = result.data.id
                req.session.currentPlayer = result.data.currentPlayer
                req.session.gameState = result.data.gameState
                req.session.state = result.data.state
                const boardHtml = GameHTMLContent.getNewBoard();
                this.sResponse.successR(res, boardHtml, 200)
            } else {
                this.handleResult(result, res)
            }

        } else {

            console.log(req.session.gameID)
            //const result = await this.useCases.retrieveGame()

        }

    }
    
    async restartGame(req: Request, res: Response) {

        const gameID = req.session.gameID;
        console.log('restarting game ID:')
        console.log(gameID)
        if(!gameID){return}
        const result = await this.useCases.resetGame(gameID)

        if (result.status === 'success') {
            req.session.currentPlayer = result.data.currentPlayer
            req.session.gameState = result.data.gameState
            req.session.state = result.data.state
            const boardHtml = GameHTMLContent.getNewBoard();
            this.sResponse.successR(res, boardHtml, 200)
        } else {
            this.handleResult(result, res)
        }
    }

    async makeMove(req: Request, res: Response) {

        console.log('===== body =====')
        console.log(req.body)
        console.log('===== body =====')

        const gameID = req.session.gameID
        const player = req.session.currentPlayer
        if(!gameID || !player){return}
        const position = req.body.position as CellPosition
        const result = await this.useCases.makeMove(gameID, position, player)

        if (result.status === 'success') {

            console.log('move made')
            console.log(result.data)
            console.log('move made')

            if ('cells' in result.data.state) {
                console.log('board state is an array or a dictionary')
                return
            }

            req.session.currentPlayer = result.data.currentPlayer
            req.session.gameState = result.data.gameState
            req.session.state = result.data.state

            let newTitle: GameTitle = GameTitle.Playing

            if(result.data.gameState === 'WON' && result.data.winner) {
                newTitle = result.data.winner.symbol === 'X' ? GameTitle.PlayerXWon : GameTitle.PlayerOWon
                console.log(newTitle)
            } else if (result.data.gameState === 'DRAW') {
                newTitle = GameTitle.Draw
            }

            const newMove = GameHTMLContent.getBoard(newTitle, result.data.state);

            this.sResponse.successR(res, newMove, 200)

        } else {
            console.log('something went wrong')
            this.handleResult(result, res)
        }
    }

    handleResult(result: Result<GameType>, res: Response) {
        switch (result.status) {
//            case 'success':
//                this.sResponse.successR(res, result.data, 200)
//                break
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