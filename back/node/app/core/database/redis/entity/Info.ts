import { GameState } from "../../model/GameState";
import { PlayerType } from "../../model/PlayerType";

type Info = {
    currentPlayer: PlayerType;
    gameState: GameState;
    winner?: PlayerType;
}

export {Info}