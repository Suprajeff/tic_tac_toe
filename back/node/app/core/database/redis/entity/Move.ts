import { CellPosition } from "../../model/CellPosition";
import {PlayerType} from "../../model/PlayerType";

type Move = {
    player: PlayerType;
    position: CellPosition;
}

type Moves = {
    player: PlayerType;
    positions: CellPosition[];
}

export {Move, Moves}