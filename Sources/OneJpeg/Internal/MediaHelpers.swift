import Foundation
import OneWireFormat

enum MediaHeaders {
    static let acceptImage = ["Accept": "image/*"]
    static let acceptAll = ["Accept": "*/*"]
}

func archiveTimeString(from date: Date) -> String {
    Timestamp.utc.string(from: date)
}

func noCacheToken() -> String {
    UUID().uuidString
}
