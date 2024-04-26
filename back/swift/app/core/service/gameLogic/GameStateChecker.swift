import Foundation

protocol GameStateCheckerB {
    func checkForVictoryOrDrawA(cells: [[CellType?]]) -> Result<GameResult>;
    func checkForVictoryOrDrawB(cells: [CellPosition: CellType?]) -> Result<GameResult>;
    func checkForVictoryOrDrawC(playersMoves: [CellType: [CellPosition]]) -> Result<GameResult>;
}

class GameStateChecker: GameStateCheckerB {

    func checkForVictoryOrDrawA(cells: [[CellType?]]) -> Result<GameResult> {

        for (a, b, c) in WinningCombinationsForArray {

            let cell1 = cells[a / 3][a % 3]
            let cell2 = cells[b / 3][b % 3]
            let cell3 = cells[c / 3][c % 3]

            if let cellSymbol = cell1, cellSymbol == cell2, cell2 == cell3 {
                return .success(GameResult(winner: PlayerType(symbol: cellSymbol), draw: false))
            }

        }

        let cellAvailable = cells.contains { row in
            row.contains { cell in
                cell == nil
            }
        }

        return cellAvailable ? .notFound : success(GameResult(winner: nil, draw: true))

    }

    func checkForVictoryOrDrawB(cells: [CellPosition: CellType?]) -> Result<GameResult> {

        for combination in winningCombinationsForDictionary {

            let pos1 = combination[0]
            let pos2 = combination[1]
            let pos3 = combination[2]
            guard let cell1 = cells[pos1], let cell2 = cells[pos2], let cell3 = cells[pos3] else {
                continue
            }

            if cell1 == cell2, cell2 == cell3 {
                return .success(GameResult(winner: PlayerType(symbol: cell1), draw: false))
            }

        }

        let cellAvailable = cells.values.contains { $0 == nil }
        return cellAvailable ? .notFound : .success(GameResult(winner: nil, draw: true))

    }

    func checkForVictoryOrDrawC(playersMoves: [CellType: [CellPosition]]) -> Result<GameResult> {
        
        let playersSymbols: [CellType] = [.X, .O]

        if let winningPlayer = playersSymbols.first(where: { player in
            let moves = playersMoves[player] ?? []
            return winningCombinationsForDictionary.contains { combination in
                combination.allSatisfy { pos in moves.contains(pos) }
            }
        }) {
            return .success(GameResult(winner: PlayerType(symbol: winningPlayer), draw: false))
        }

        let cellAvailable = 9 - (playersMoves[.X]?.count ?? 0 + playersMoves[.O]?.count ?? 0)
        return cellAvailable === 0 ? .success(GameResult(winner: nil, draw: true)) : .notFound

    }

}