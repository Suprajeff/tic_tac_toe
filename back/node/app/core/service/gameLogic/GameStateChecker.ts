import { Result } from "../../common/result/Result";
import { CellPosition } from "../../model/CellPosition";
import { CellType } from "../../model/CellType";
import { PlayerType } from "../../model/PlayerType";
import {GameResult} from "../../model/GameResult";

interface GameStateChecker {
    checkForVictoryOrDrawA(cells: CellType[][]): Result<GameResult>;
    checkForVictoryOrDrawB(cells: Record<CellPosition, CellType>): Result<GameResult>;
    checkForVictoryOrDrawC(playersHands: Record<NonNullable<CellType>, CellPosition[]>): Result<GameResult>;
}
