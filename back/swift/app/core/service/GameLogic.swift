import Foundation

protocol GameLogicB {
    func getNextPlayer() -> Result<PlayerType, Error>
    func checkForWinner() -> Result<PlayerType, Error>
    func checkForDraw() -> Result<Bool, Error>
}