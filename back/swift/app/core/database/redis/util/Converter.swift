import Foundation
import Redis

class TypeConverter {
    
    static func cellPositiontoString(_ position: CellPosition) -> String {
        switch position {
        case .TL:
            return "TL"
        case .T:
            return "T"
        case .TR:
            return "TR"
        case .L:
            return "L"
        case .C:
            return "C"
        case .R:
            return "R"
        case .BL:
            return "BL"
        case .B:
            return "B"
        case .BR:
            return "BR"
        }
    }
    
    static func stringToCellPosition(_ string: String) -> CellPosition? {
        switch string {
        case "TL":
            return .TL
        case "T":
            return .T
        case "TR":
            return .TR
        case "L":
            return .L
        case "C":
            return .C
        case "R":
            return .R
        case "BL":
            return .BL
        case "B":
            return .B
        case "BR":
            return .BR
        default:
            return nil
        }
    }
    
    static func playerTypeToString(_ playerType: PlayerType) -> String {
        switch playerType.symbol {
        case .X:
            return "X"
        case .O:
            return "O"
        }
    }
    
    static func stringToPlayerType(_ string: String) -> PlayerType? {
        switch string {
        case "X":
            return PlayerType(symbol: .X)
        case "O":
            return PlayerType(symbol: .O)
        default:
            return nil
        }
    }
    
    static func extractString(from respValue: RESPValue) -> String? {
        if case .bulkString(let string) = respValue {
            return string
        }
        return nil
    }
    
}