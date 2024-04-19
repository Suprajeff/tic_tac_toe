import { CellType } from "./CellType";
import {CellPosition} from "./CellPosition";

type BoardType = {
    cells: CellType[][] | Record<CellPosition, CellType>;
}

export {BoardType}