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
        let newID = UUID().uuidString
        return .success(newID)
    }

    func generateNewBoard() -> Result<BoardType, Error> {
        return Array(repeating: Array(repeating: nil, count: 3), count: 3)
    }

    func randomPlayer() -> Result<PlayerType, Error> {
        let symbols = ["X", "O"].shuffled()
        guard let symbol = symbols.first else {
            return .failure(GameError.couldNotGetPlayer)
        }
        return .success(PlayerType(symbol: symbol))
    }

    func getNextPlayer(currentPlayer: PlayerType) -> Result<PlayerType, Error> {
        let nextSymbol = currentPlayer.symbol == "X" ? "O" : "X"
        return .success(PlayerType(symbol: nextSymbol))
    }

    func checkForWinner(state: StateType) -> Result<PlayerType, Error> {

    }

}