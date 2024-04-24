import Foundation

protocol GameLogicB {
    func generateNewID() -> Result<String, Error>
    func generateNewBoard() -> Result<BoardType, Error>
    func randomPlayer() -> Result<PlayerType, Error>
    func getNextPlayer() -> Result<PlayerType, Error>
    func checkForWinner() -> Result<PlayerType, Error>
    func checkForDraw() -> Result<Bool, Error>
}