import { BoardType } from "./BoardType";
import { GameState } from "./GameState";
import { PlayerType } from "./PlayerType";

type GameType = {
    id: string;
    board: BoardType;
    currentPlayer: PlayerType;
    gameState: GameState;
    winner?: PlayerType; 
}

export {GameType}