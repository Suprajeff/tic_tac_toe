import Foundation

protocol GameLogicB {
    func generateNewID() -> Result<String, Error>
    func generateNewBoard() -> Result<BoardType, Error>
    func randomPlayer() -> Result<PlayerType, Error>
    func getNextPlayer(currentPlayer: PlayerType) -> Result<PlayerType, Error>
    func checkForWinner(state: StateType) -> Result<PlayerType, Error>
}

class GameLogic: GameLogicB {

    func generateNewID() -> Result<String, Error> {

    }

    func generateNewBoard() -> Result<BoardType, Error> {

    }

    func randomPlayer() -> Result<PlayerType, Error> {

    }

    func getNextPlayer(currentPlayer: PlayerType) -> Result<PlayerType, Error> {

    }

    func checkForWinner(state: StateType) -> Result<PlayerType, Error> {

    }

}