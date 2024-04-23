import { CellPosition } from "./CellPosition";
import { CellType } from "./CellType";

type PlayersMoves = Record<NonNullable<CellType>, CellPosition[]>;

export {PlayersMoves}