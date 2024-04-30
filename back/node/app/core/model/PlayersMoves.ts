import { CellPosition } from "./CellPosition.js";
import { CellType } from "./CellType.js";

type PlayersMoves = Record<NonNullable<CellType>, CellPosition[]>;

export {PlayersMoves}