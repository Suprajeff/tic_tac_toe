import { CellPosition } from "../../../model/CellPosition.js";
import {PlayerType} from "../../../model/PlayerType.js";

type Move = {
    player: PlayerType;
    position: CellPosition;
}

type Moves = {
    player: PlayerType;
    positions: CellPosition[];
}

export {Move, Moves}