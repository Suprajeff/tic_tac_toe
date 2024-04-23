import { GameState } from "./GameState";
import { PlayerType } from "./PlayerType";
import {StateType} from "./StateType";

type GameType = {
    id: string;
    currentPlayer: PlayerType;
    gameState: GameState;
    state: StateType;
    winner?: PlayerType; 
}

export {GameType}