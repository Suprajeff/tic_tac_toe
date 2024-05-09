import {GameController} from "../controllers/GameController.js";
import {Router} from "express";

class GameEndpoints {
    
    constructor(
        private controller: GameController,
        private router: Router
    ) {
       this.initializeRoutes()
    }

    initializeRoutes() {
        this.router.get('/hello', (req, res) => this.controller.helloWorld(res));
        this.router.get('/start', (req, res) => this.controller.startGame(res));
        this.router.get('/restart', (req, res) => this.controller.restartGame(req, res));
        this.router.post('/move', (req, res) => this.controller.makeMove(req, res));
    }
    
}

export {GameEndpoints}