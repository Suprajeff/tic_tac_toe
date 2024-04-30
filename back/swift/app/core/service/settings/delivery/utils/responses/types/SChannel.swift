import Foundation
import Vapor
import WebSocketKit

enum SChannel {
    case httpResponse(Response)
    case webSocker(WebSocket)
}
