import Foundation

struct CustomError: Error {
    let message: String
    
    init(_ message: String) {
        self.message = message
    }
}