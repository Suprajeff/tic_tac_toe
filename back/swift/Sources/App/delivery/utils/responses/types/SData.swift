import Foundation
import Vapor
import WebSocketKit

enum SData {
    case json(JSONData)
    case html(String)
}

struct JSONData: Content  {

    enum JSONDataType {
        case data(Data)
        case error(String)
    }

    let type: JSONDataType

    init(_ data: Data) {
        self.type = .data(data)
    }

    init(_ error: String) {
        self.type = .error(error)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let data = try? container.decode(Data.self) {
            self.type = .data(data)
        } else if let errorString = try? container.decode(String.self) {
            self.type = .error(errorString)
        } else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath, debugDescription: "Invalid data type"))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch type {
        case .data(let data):
            try container.encode(data)
        case .error(let errorString):
            try container.encode(errorString)
        }
    }

}