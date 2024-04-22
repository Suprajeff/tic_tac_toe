import {PlayerType} from "../../model/PlayerType";
import {BoardType} from "../../model/BoardType";
import {GameType} from "../../model/GameType";
import { Result } from "../../common/result/Result";

interface GameRepository {
    createNewGame(newKey: string, board: BoardType, player: PlayerType): Promise<Result<GameType>>;
    resetGame(gameID: string, board: BoardType, player: PlayerType): Promise<Result<GameType>>;
    updateBoard(row: number, col: number, player: PlayerType): Promise<Result<GameType>>;
    switchCurrentPlayer(gameID: string): Promise<Result<GameType>>;
    getCurrentPlayer(gameID: string): Promise<Result<PlayerType>>;
    getBoardState(gameID: string): Promise<Result<BoardType>>;
    getGameState(gameID: string): Promise<Result<GameType>>;
}

export {GameRepository}