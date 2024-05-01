import {Request, Response} from "express"
import { GameUseCasesB } from "../../../../core/domain/GameUseCases.js";
import {GameResponses} from "../../../utils/responses/SResponses.js";
import {CellPosition} from "../../../../core/model/CellPosition.js";
import {PlayerType} from "../../../../core/model/PlayerType.js";
import { Result } from "../../../../core/common/result/Result.js";
import { GameType } from "../../../../core/model/GameType.js";

class GameController {
    
    constructor(private useCases: GameUseCasesB, private sResponse: GameResponses) {}
    
    async helloWorld(req: Request, res: Response) {
        res.status(200).send("Hello, Node!");
    }
    async startGame(res: Response) {
        const result = await this.useCases.initializeGame()
        this.handleResult(result, res.status(200))
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