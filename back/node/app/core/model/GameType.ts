import { BoardType } from "./BoardType";
import { GameState } from "./GameState";
import { PlayerType } from "./PlayerType";

type GameType = {
    board: BoardType;
    currentPlayer: PlayerType;
    gameState: GameState;
    winner?: PlayerType; 
}

export {GameType}