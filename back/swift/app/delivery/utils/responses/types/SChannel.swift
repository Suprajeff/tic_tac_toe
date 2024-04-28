import Foundation
import Vapor

enum SChannel {
    case httpResponse(Response)
    case webSocker(WebSocket)
}
