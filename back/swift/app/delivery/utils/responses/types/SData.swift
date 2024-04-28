import Foundation
import Vapor
import WebSocketKit

enum SData {
    case json(JSONData)
    case html(String)
}

struct JSONData: Content  {

    let data: Data

    init(_ data: Data) {
        self.data = data
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        data = try container.decode(Data.self)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(data)
    }

}