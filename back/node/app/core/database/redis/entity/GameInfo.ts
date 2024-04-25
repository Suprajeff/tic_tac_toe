import { CellType } from "../../../model/CellType";
import { GameState } from "../../../model/GameState";
import { PlayerType } from "../../../model/PlayerType";

type GameInfo = {
    currentPlayer: PlayerType;
    gameState: GameState;
    winner: PlayerType | undefined;
}

export {GameInfo}