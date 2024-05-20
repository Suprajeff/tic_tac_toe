import Vapor
import WebSocketKit

class GameResponses {
    
    private func sendHTTPResponse(req: Request, data: SData, statusCode: HTTPResponseStatus) -> Response {

//        let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
//        let eventLoop = eventLoopGroup.next()
        let response = Response(status: statusCode)

        switch data {
            case .json(let jsonData):
                response.headers.contentType = .json
                try? response.content.encode(jsonData)
            case .html(let htmlString):
                response.headers.contentType = .html
                response.body = .init(string: htmlString)
        }

//        return req.eventLoop.makeSucceededFuture(response)

        return response

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

    func informationR(req: Request, data: SData, statusCode: Status.Informational) -> Response {
        return sendHTTPResponse(req: req, data: data, statusCode: statusCode.httpResponseStatus)
    }

    func successR(req: Request, data: SData, statusCode: Status.Success) -> Response {
        return sendHTTPResponse(req: req, data: data, statusCode: statusCode.httpResponseStatus)
    }

    func redirectionR(req: Request, data: SData, statusCode: Status.Redirection) -> Response {
        return sendHTTPResponse(req: req, data: data, statusCode: statusCode.httpResponseStatus)
    }

    func clientErrR(req: Request, data: SData, statusCode: Status.ClientError) -> Response {
        return sendHTTPResponse(req: req, data: data, statusCode: statusCode.httpResponseStatus)
    }

    func serverErrR(req: Request, data: SData, statusCode: Status.ServerError) -> Response {
        return sendHTTPResponse(req: req, data: data, statusCode: statusCode.httpResponseStatus)
    }

    func socketR(socket: WebSocket, data: SData, room: String? = nil) {
        sendSocketResponse(socket: socket, data: data, room: room)
    }
}

