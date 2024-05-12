import {error, Result} from "../common/result/Result.js";
import {GameType} from "../model/GameType.js";
import {PlayerType} from "../model/PlayerType.js";
import {GameRepository} from "../data/repository/GameRepository.js";
import {CellPosition} from "../model/CellPosition.js";
import {GameLogic} from "../service/game/GameLogic.js";
import {GameState} from "../model/GameState.js";

interface GameUseCasesB {
    initializeGame(): Promise<Result<GameType>>;
    retrieveGame(gameID: string): Promise<Result<GameType>>;
    resetGame(gameID: string): Promise<Result<GameType>>;
    makeMove(gameID: string, position: CellPosition, player: PlayerType): Promise<Result<GameType>>;
}

class GameUseCases implements GameUseCasesB {

    private gameRepo: GameRepository
    private gameProcess: GameLogic


    constructor(repository: GameRepository, logic: GameLogic) {
        this.gameRepo = repository
        this.gameProcess = logic
    }

    async initializeGame(): Promise<Result<GameType>> {
        const newKey = this.gameProcess.generateNewID()
        const board = this.gameProcess.generateNewBoard()
        const player = this.gameProcess.randomPlayer()
        if(newKey.status !== 'success' || player.status !== 'success'){return error('something went wrong')}
        return  await this.gameRepo.createNewGame(newKey.data, board, player.data)
    }

    async retrieveGame(gameID: string): Promise<Result<GameType>> {
        return  await this.gameRepo.getGameState(gameID)
    }

    async resetGame(gameID: string): Promise<Result<GameType>> {
        const board = this.gameProcess.generateNewBoard()
        const player = this.gameProcess.randomPlayer()
        if(player.status !== 'success'){return error('something went wrong')}
        return  await this.gameRepo.resetGame(gameID, board, player.data)
    }

    async makeMove(gameID: string, position: CellPosition, player: PlayerType): Promise<Result<GameType>> {

        const newBoardState = await this.gameRepo.updateBoard(gameID, position, player)
        if(newBoardState.status !== 'success'){return error('something went wrong when trying to retrieve board state')}

        const checkWinnerAndDraw = this.gameProcess.checkForWinner(newBoardState.data)
        if(checkWinnerAndDraw.status === 'error'){return error('something went wrong when trying to check for victory')}

        let gameState: GameState = GameState.InProgress
        let winner: PlayerType | undefined = undefined

        if(checkWinnerAndDraw.status === 'success'){
            if(checkWinnerAndDraw.data.draw){
                gameState = GameState.Draw
            }
            if(checkWinnerAndDraw.data.winner){
                gameState= GameState.Won
                winner = checkWinnerAndDraw.data.winner
            }
        }

        const nextPlayer = this.gameProcess.getNextPlayer(player)
        if(nextPlayer.status !== 'success'){return error('something went wrong when trying to retrieve next player')}

        return await this.gameRepo.updateGameState(gameID, newBoardState.data, {currentPlayer: nextPlayer.data, gameState: gameState, winner: winner})
    }

}

export {GameUseCasesB, GameUseCases}