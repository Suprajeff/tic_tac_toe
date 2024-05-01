import Vapor
import WebSocketKit

class GameResponses {
    
    private func sendHTTPResponse(data: SData, statusCode: HTTPResponseStatus) -> EventLoopFuture<Response> {

        let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        let eventLoop = eventLoopGroup.next()
        let response = Response(status: statusCode)

        switch data {
            case .json(let jsonData):
                response.headers.contentType = .json
                try? response.content.encode(jsonData)
            case .html(let htmlString):
                response.headers.contentType = .html
                response.body = .init(string: htmlString)
        }

        return eventLoop.makeSucceededFuture(response)

    }

    private func sendSocketResponse(socket: WebSocket, data: SData, room: String? = nil) {

    switch data {

        case .json(let jsonData):
            if let room = room {
               // Send to all connected user
                print(room)
            } else {
                guard let data = try? JSONEncoder().encode(jsonData) else {
                    print("Failed to encode JSON data")
                    return
                }
                socket.send(ByteBuffer(data: data), opcode: .binary)
            }

        case .html(let htmlString):
            if let room = room {
                // Send to all connected user
                print(room)
            } else {
                socket.send(htmlString)
            }

    }

    }

    func informationR(data: SData, statusCode: Status.Informational) -> EventLoopFuture<Response> {
        sendHTTPResponse(data: data, statusCode: statusCode.httpResponseStatus)
    }

    func informationR(socket: WebSocket, data: SData, room: String? = nil) {
        sendSocketResponse(socket: socket, data: data, room: room)
    }

    func successR(data: SData, statusCode: Status.Success) -> EventLoopFuture<Response> {
        sendHTTPResponse(data: data, statusCode: statusCode.httpResponseStatus)
    }

    func successR(socket: WebSocket, data: SData, room: String? = nil) {
        sendSocketResponse(socket: socket, data: data, room: room)
    }

    func redirectionR(data: SData, statusCode: Status.Redirection) -> EventLoopFuture<Response> {
        sendHTTPResponse(data: data, statusCode: statusCode.httpResponseStatus)
    }

    func redirectionR(socket: WebSocket, data: SData, room: String? = nil) {
        sendSocketResponse(socket: socket, data: data, room: room)
    }

    func clientErrR(data: SData, statusCode: Status.ClientError) -> EventLoopFuture<Response> {
        sendHTTPResponse(data: data, statusCode: statusCode.httpResponseStatus)
    }

    func clientErrR(socket: WebSocket, data: SData, room: String? = nil) {
        sendSocketResponse(socket: socket, data: data, room: room)
    }

    func serverErrR(data: SData, statusCode: Status.ServerError) -> EventLoopFuture<Response> {
        sendHTTPResponse(data: data, statusCode: statusCode.httpResponseStatus)
    }

    func serverErrR(socket: WebSocket, data: SData, room: String? = nil) {
        sendSocketResponse(socket: socket, data: data, room: room)
    }
}

