import {PlayerType} from "../../model/PlayerType";
import {BoardType} from "../../model/BoardType";
import {GameType} from "../../model/GameType";
import { Result } from "../../common/result/Result";
import {CellPosition} from "../../model/CellPosition";
import {StateType} from "../../model/StateType";
import {GameInfo} from "../../database/redis/entity/GameInfo";

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