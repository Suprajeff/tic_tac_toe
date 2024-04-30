import { GameState } from "./GameState.js";
import { PlayerType } from "./PlayerType.js";
import {StateType} from "./StateType.js";

type GameType = {
    id: string;
    currentPlayer: PlayerType;
    gameState: GameState;
    state: StateType;
    winner?: PlayerType; 
}

export {GameType}