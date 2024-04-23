import { BoardType } from "./BoardType";
import { GameState } from "./GameState";
import { PlayerType } from "./PlayerType";
import { PlayersMoves } from "./PlayersMoves";

type GameType = {
    id: string;
    currentPlayer: PlayerType;
    gameState: GameState;
    state: BoardType | PlayersMoves;
    winner?: PlayerType; 
}

export {GameType}