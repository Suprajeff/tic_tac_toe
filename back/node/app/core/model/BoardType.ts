import { CellType } from "./CellType.js";
import {CellPosition} from "./CellPosition.js";

type BoardType = {
    cells: CellType[][] | Record<CellPosition, CellType>;
}

export {BoardType}