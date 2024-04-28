import Vapor
import WebSocketKit

class GameResponses {
    
    private func sendResponse(_ res: SChannel, _ data: SData, _ statusCode: HTTPResponseStatus? = nil, _ room: String? = nil) {

        switch res {
        case .httpResponse(let response):
            switch data {
            case .json(let jsonData):
                if let statusCode = statusCode {
                    response.status = statusCode
                }
                response.headers.contentType = .json
                try? response.content.encode(jsonData)
            case .html(let htmlString):
                if let statusCode = statusCode {
                    response.status = statusCode
                }
                response.headers.contentType = .html
                response.body = .init(string: htmlString)
            }

        case .webSocker(let webSocket):
            switch data {
            case .json(let jsonData):
                if let room = room {
                   // Send to all connected user
                } else {
                    guard let data = try? JSONEncoder().encode(jsonData) else {
                        print("Failed to encode JSON data")
                        return
                    }
                    webSocket.send(ByteBuffer(data: data), opcode: .binary)
                }
            case .html(let htmlString):
                if let room = room {
                    // Send to all connected user
                } else {
                    webSocket.send(htmlString)
                }
            }
        }

    }

    func informationR(res: SChannel, data: SData, statusCode: Status.Informational? = nil, room: String? = nil) {
        sendResponse(res, data, statusCode?.httpResponseStatus, room)
    }

    func successR(res: SChannel, data: SData, statusCode: Status.Success? = nil, room: String? = nil) {
        sendResponse(res, data, statusCode?.httpResponseStatus, room)
    }

    func redirectionR(res: SChannel, data: SData, statusCode: Status.Redirection? = nil, room: String? = nil) {
        sendResponse(res, data, statusCode?.httpResponseStatus, room)
    }

    func clientErrR(res: SChannel, data: SData, statusCode: Status.ClientError? = nil, room: String? = nil) {
        sendResponse(res, data, statusCode?.httpResponseStatus, room)
    }

    func serverErrR(res: SChannel, data: SData, statusCode: Status.ServerError? = nil, room: String? = nil) {
        sendResponse(res, data, statusCode?.httpResponseStatus, room)
    }
}

