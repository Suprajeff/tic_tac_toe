import Foundation

protocol GameStateCheckerB {
    func checkForVictoryOrDrawA(cells: [[CellType?]]) -> Result<GameResult>;
    func checkForVictoryOrDrawB(cells: [CellPosition: CellType?]) -> Result<GameResult>;
    func checkForVictoryOrDrawC(playersHands: [CellType: [CellPosition]]) -> Result<GameResult>;
}

class GameStateChecker: GameStateCheckerB {

    func checkForVictoryOrDrawA(cells: [[CellType?]]) -> Result<GameResult> {

    }

    func checkForVictoryOrDrawB(cells: [CellPosition: CellType?]) -> Result<GameResult> {

    }

    func checkForVictoryOrDrawC(playersHands: [CellType: [CellPosition]]) -> Result<GameResult> {
        
    }

}