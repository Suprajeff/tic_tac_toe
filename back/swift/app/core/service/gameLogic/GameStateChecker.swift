import Foundation

protocol GameStateChecker {
    func checkForVictoryOrDrawA(cells: [[CellType?]]) -> Result<GameResult>;
    func checkForVictoryOrDrawB(cells: [CellPosition: CellType?]) -> Result<GameResult>;
    func checkForVictoryOrDrawC(playersHands: [CellType: [CellPosition]]) -> Result<GameResult>;
}