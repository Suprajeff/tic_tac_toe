import {Request, Response} from "express"
import { GameUseCasesB } from "../../../../core/domain/GameUseCases";
import {GameResponses} from "../../../utils/responses/SResponses";
import {CellPosition} from "../../../../core/model/CellPosition";
import {PlayerType} from "../../../../core/model/PlayerType";

class GameController {
    
    constructor(private useCases: GameUseCasesB, private sResponse: GameResponses) {}
    
    async startGame(req: Request, res: Response) {
        const { format, channel } = req.body;
        const result = await this.useCases.initializeGame()
        switch (result.status) {
            case 'success':
                this.sResponse.successR(res, result.data, 200, format, channel)
                break
            case 'error':
                this.sResponse.serverErrR(res, null,500, format, channel)
                break
            case 'notFound':
                this.sResponse.clientErrR(res, null,400, format, channel)
                break
        }
    }
    
    async restartGame(req: Request, res: Response) {
        const { gameID, format, channel } = req.body;
        const result = await this.useCases.resetGame(gameID)
        switch (result.status) {
            case 'success':
                this.sResponse.successR(res, result.data, 200, format, channel)
                break
            case 'error':
                this.sResponse.serverErrR(res, null,500, format, channel)
                break
            case 'notFound':
                this.sResponse.clientErrR(res, null,400, format, channel)
                break
        }
    }
    
    async makeMove(req: Request, res: Response) {
        const { gameID, positionData, playerData, format, channel } = req.body;
        const position: CellPosition = JSON.parse(positionData);
        const player: PlayerType = JSON.parse(playerData);
        const result = await this.useCases.makeMove(gameID, position, player)
        switch (result.status) {
            case 'success':
                this.sResponse.successR(res, result.data, 200, format, channel)
                break
            case 'error':
                this.sResponse.serverErrR(res, null,500, format, channel)
                break
            case 'notFound':
                this.sResponse.clientErrR(res, null,400, format, channel)
                break
        }
    }
    
}

export {GameController}