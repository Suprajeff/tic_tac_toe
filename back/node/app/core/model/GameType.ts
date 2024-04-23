import { BoardType } from "./BoardType";
import { GameState } from "./GameState";
import { PlayerType } from "./PlayerType";
import { PlayersMoves } from "./PlayersMoves";

type GameType = {
    id: string;
    board: BoardType;
    currentPlayer: PlayerType;
    gameState: GameState;
    moves?: PlayersMoves;
    winner?: PlayerType; 
}

export {GameType}