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

    func checkForWinner(state: StateType) -> Result<Bool, CellType?> {

        let winningCombinations: [[CellPosition]] = [
            [.TL, .T, .TR], [.L, .C, .R], [.BL, .B, .BR], // Rows
            [.TL, .L, .BL], [.T, .C, .B], [.TR, .R, .BR], // Columns
            [.TL, .C, .BR], [.TR, .C, .BL] // Diagonals
        ]

        let cells: [CellPosition: CellType]

        switch boardState {
        case .board(let boardType):
            switch boardType.cells {
            case .arrayOfArrays(let arrayOfArrays):
                cells = Dictionary(arrayOfArrays.flatMap { $0 }.enumerated().map { ($1.0, $1.1) }, uniquingKeysWith: { _, last in last })
            case .dictionary(let dictionary):
                cells = dictionary
            }
        case .moves(let playerMoves):
            cells = Dictionary(playerMoves.flatMap { (player, moves) in moves.map { ($0, player) } }, uniquingKeysWith: { _, last in last })
        }

        for combination in winningCombinations {
            let [pos1, pos2, pos3] = combination
            guard let cell1 = cells[pos1],
                let cell2 = cells[pos2],
                let cell3 = cells[pos3],
                cell1 == cell2,
                cell2 == cell3 else {
                continue
            }
            return .success(true, cell1)
        }

        return .success(false, nil)

    }

}