import Foundation

struct GameInfoError: Error {
    let description: String
    
    init(_ description: String) {
        self.description = description
    }
}