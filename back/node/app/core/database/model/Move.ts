import { CellPosition } from "../../model/CellPosition";
import {PlayerType} from "../../model/PlayerType";

interface PlayerMove {
    player: PlayerType;
    position: CellPosition;
}