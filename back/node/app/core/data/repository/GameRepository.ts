import {PlayerType} from "../../model/PlayerType";
import {BoardType} from "../../model/BoardType";
import {GameType} from "../../model/GameType";
import { Result } from "../../common/result/Result";

interface GameRepository {
    createNewGame(): Promise<Result<GameType>>;
    resetGame(): Promise<Result<GameType>>;
    updateBoard(row: number, col: number, player: PlayerType): Promise<Result<GameType>>;
    switchCurrentPlayer(): Promise<Result<GameType>>;
    getCurrentPlayer(): Promise<Result<PlayerType>>;
    getBoardState(): Promise<Result<BoardType>>;
}