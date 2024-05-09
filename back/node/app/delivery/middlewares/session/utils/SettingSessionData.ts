import 'express-session';
import {PlayerType} from "../../../../core/model/PlayerType.js";
import {GameState} from "../../../../core/model/GameState.js";
import {StateType} from "../../../../core/model/StateType.js";

declare module 'express-session' {
    interface SessionData {
        gameID: string;
        currentPlayer: PlayerType;
        gameState: GameState;
        state: StateType;
        darkMode: string;
    }
}