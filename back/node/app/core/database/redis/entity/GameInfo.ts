import { GameState } from "../../../model/GameState.js";
import { PlayerType } from "../../../model/PlayerType.js";

type GameInfo = {
    currentPlayer: PlayerType;
    gameState: GameState;
    winner: PlayerType | undefined;
}

export {GameInfo}