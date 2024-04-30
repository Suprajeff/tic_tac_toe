import {PlayerType} from "../../model/PlayerType.js";
import {BoardType} from "../../model/BoardType.js";
import {GameType} from "../../model/GameType.js";
import { Result } from "../../common/result/Result.js";
import {CellPosition} from "../../model/CellPosition.js";
import {StateType} from "../../model/StateType.js";
import {GameInfo} from "../../database/redis/entity/GameInfo.js";

interface GameRepository {
    createNewGame(newKey: string, board: BoardType, player: PlayerType): Promise<Result<GameType>>;
    resetGame(gameID: string, board: BoardType, player: PlayerType): Promise<Result<GameType>>;
    updateBoard(gameID: string, position: CellPosition, player: PlayerType): Promise<Result<StateType>>;
    getCurrentPlayer(gameID: string): Promise<Result<PlayerType>>;
    getBoardState(gameID: string): Promise<Result<StateType>>;
    getGameState(gameID: string): Promise<Result<GameType>>;
    updateGameState(gameID: string, board: StateType, gameInfo: GameInfo): Promise<Result<GameType>>;
}

export {GameRepository}