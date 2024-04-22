import {CellPosition} from "../../../model/CellPosition";
import { GameState } from "../../../model/GameState";
import { PlayerType } from "../../../model/PlayerType";
import {CellType} from "../../../model/CellType";

type Game = {
    id: string;
    moves: Record<NonNullable<CellType>, CellPosition[]>;
    currentPlayer: PlayerType;
    gameState: GameState;
    winner?: PlayerType; 
}

export {Game}