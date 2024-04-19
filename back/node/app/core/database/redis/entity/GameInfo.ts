import { GameState } from "../../model/GameState";
import { PlayerType } from "../../model/PlayerType";

type GameInfo = {
    currentPlayer: PlayerType;
    gameState: GameState;
    winner?: PlayerType;
}

export {Info}