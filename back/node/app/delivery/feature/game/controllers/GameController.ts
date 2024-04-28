import {Request, Response} from "express"
import { GameUseCasesB } from "../../../../core/domain/GameUseCases";

class GameController {
    
    constructor(private useCases: GameUseCasesB) {}
    
    async startGame(req: Request, res: Response) {
        
    }
    
    async restartGame(req: Request, res: Response) {
        
    }
    
    async makeMove(req: Request, res: Response) {
        
    }
    
}

export {GameController}