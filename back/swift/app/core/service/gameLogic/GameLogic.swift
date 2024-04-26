import Foundation

protocol GameLogicB {
    func generateNewID() -> Result<String, Error>
    func generateNewBoard() -> Result<BoardType, Error>
    func randomPlayer() -> Result<PlayerType, Error>
    func getNextPlayer(currentPlayer: PlayerType) -> Result<PlayerType, Error>
    func checkForWinner(state: StateType) -> Result<GameResult, Error>
}

class GameLogic: GameLogicB {

    private let checker: GameStateCheckerB

    init(gameStateChecker: GameStateCheckerB) {
        self.checker = gameStateChecker
    }

    func generateNewID() -> Result<String, Error> {
        let newID = UUID().uuidString
        return .success(newID)
    }

    func generateNewBoard() -> Result<BoardType, Error> {
        return .success(BoardType(cells: .arrayOfArrays(Array(repeating: Array(repeating: nil, count: 3), count: 3))))
    }

    func randomPlayer() -> Result<PlayerType, Error> {
        let symbols = [CellType.X, CellType.O].shuffled()
        guard let symbol = symbols.first else {
            return .failure(CustomError("Could not get symbol"))
        }
        return .success(PlayerType(symbol: symbol))
    }

    func getNextPlayer(currentPlayer: PlayerType) -> Result<PlayerType, Error> {
        let nextSymbol = currentPlayer.symbol == CellType.X ? CellType.O : CellType.X
        return .success(PlayerType(symbol: nextSymbol))
    }

    func checkForWinner(state: StateType) -> Result<GameResult, Error> {

        switch state {
        case .board(let boardType):
            switch boardType.cells {
            case .arrayOfArrays(let arrayOfArrays):
                return checker.checkForVictoryOrDrawA(arrayOfArrays)
            case .dictionary(let dictionary):
                return checker.checkForVictoryOrDrawB(dictionary)
            }
        case .moves(let playerMoves):
            return checker.checkForVictoryOrDrawC(playerMoves)
        }

    }

}