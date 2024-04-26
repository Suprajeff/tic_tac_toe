import Foundation

protocol GameStateCheckerB {
    func checkForVictoryOrDrawA(cells: [[CellType?]]) -> Result<GameResult, Error>;
    func checkForVictoryOrDrawB(cells: [CellPosition: CellType?]) -> Result<GameResult, Error>;
    func checkForVictoryOrDrawC(playersMoves: [CellType: [CellPosition]]) -> Result<GameResult, Error>;
}

class GameStateChecker: GameStateCheckerB {

    func checkForVictoryOrDrawA(cells: [[CellType?]]) -> Result<GameResult, Error> {

        for (a, b, c) in winningCombinationsForArray {

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

        return cellAvailable ? .notFound : .success(GameResult(winner: nil, draw: true))

    }

    func checkForVictoryOrDrawB(cells: [CellPosition: CellType?]) -> Result<GameResult, Error> {

        for combination in winningCombinationsForDictionary {

            let pos1 = combination[0]
            let pos2 = combination[1]
            let pos3 = combination[2]
            guard let cell1 = cells[pos1], let cell2 = cells[pos2], let cell3 = cells[pos3] else {
                continue
            }

            if let cellSymbol = cell1, cell1 == cell2, cell2 == cell3 {
                return .success(GameResult(winner: PlayerType(symbol: cellSymbol), draw: false))
            }

        }

        let cellAvailable = cells.values.contains { $0 == nil }
        return cellAvailable ? .notFound : .success(GameResult(winner: nil, draw: true))

    }

    func checkForVictoryOrDrawC(playersMoves: [CellType: [CellPosition]]) -> Result<GameResult, Error> {
        
        let playersSymbols: [CellType] = [.X, .O]

        if let winningPlayer = playersSymbols.first(where: { player in
            let moves = playersMoves[player] ?? []
            return winningCombinationsForDictionary.contains { combination in
                combination.allSatisfy { pos in moves.contains(pos) }
            }
        }) {
            return .success(GameResult(winner: PlayerType(symbol: winningPlayer), draw: false))
        }

        var cellAvailable: Int = 9
        if let xMoves = playersMoves[.X], let oMoves = playersMoves[.O] {
            cellAvailable -= (xMoves.count + oMoves.count)
        }
        return cellAvailable == 0 ? .success(GameResult(winner: nil, draw: true)) : .notFound

    }

}