import {Request, Response} from "express"
import { GameUseCasesB } from "../../../../core/domain/GameUseCases";
import {GameResponses} from "../../../utils/responses/SResponses";
import {CellPosition} from "../../../../core/model/CellPosition";
import {PlayerType} from "../../../../core/model/PlayerType";
import { Result } from "../../../../core/common/result/Result";
import { GameType } from "../../../../core/model/GameType";

class GameController {
    
    constructor(private useCases: GameUseCasesB, private sResponse: GameResponses) {}
    
    async startGame(res: Response) {
        const result = await this.useCases.initializeGame()
        this.handleResult(result, res)
    }
    
    async restartGame(req: Request, res: Response) {
        const { gameID } = req.body;
        const result = await this.useCases.resetGame(gameID)
        this.handleResult(result, res)
    }

    async makeMove(req: Request, res: Response) {
        const { gameID, positionData, playerData } = req.body;
        const position: CellPosition = JSON.parse(positionData);
        const player: PlayerType = JSON.parse(playerData);
        const result = await this.useCases.makeMove(gameID, position, player)
        this.handleResult(result, res)
    }

    handleResult(result: Result<GameType>, res: Response) {
        switch (result.status) {
            case 'success':
                this.sResponse.successR(res, result.data, 200)
                break
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