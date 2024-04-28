import Vapor

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
                    webSocket.emit("json", jsonData, to: .room(room))
                } else {
                    webSocket.emit("json", jsonData)
                }
            case .html(let htmlString):
                if let room = room {
                    webSocket.emit("html", htmlString, to: .room(room))
                } else {
                    webSocket.emit("html", htmlString)
                }
            }
        }

    }

    func informationR(res: SChannel, data: SData, statusCode: Status.Informational? = nil, room: String? = nil) {
        if let statusCode = statusCode {
            let code = statusCode.rawValue
            sendResponse(res, data, code, room)
        } else {
            sendResponse(res, data, nil, room)
        }
    }

    func successR(res: SChannel, data: SData, statusCode: Status.Success? = nil, room: String? = nil) {
        sendResponse(res, data, statusCode?.rawValue, room)
    }

    func redirectionR(res: SChannel, data: SData, statusCode: Status.Redirection? = nil, room: String? = nil) {
        sendResponse(res, data, statusCode?.rawValue, room)
    }

    func clientErrR(res: SChannel, data: SData, statusCode: Status.ClientError? = nil, room: String? = nil) {
        sendResponse(res, data, statusCode?.rawValue, room)
    }

    func serverErrR(res: SChannel, data: SData, statusCode: Status.ServerError? = nil, room: String? = nil) {
        sendResponse(res, data, statusCode?.rawValue, room)
    }
}

