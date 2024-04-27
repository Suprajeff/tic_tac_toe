import {GameController} from "../controllers/GameController";
import {Router} from "express";

class GameEndpoints {
    
    constructor(
        private controller: GameController,
        private router: Router
    ) {
       this.initializeRoutes 
    }

    initializeRoutes() {
        this.router.post('/start', (req, res) => this.controller.startGame(req, res));
        this.router.post('/restart', (req, res) => this.controller.restartGame(req, res));
        this.router.post('/move', (req, res) => this.controller.makeMove(req, res));
    }
    
}

export {GameEndpoints}