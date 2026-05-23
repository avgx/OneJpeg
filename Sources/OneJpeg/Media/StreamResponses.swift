import Foundation
import OneWireFormat

public struct RenderedInfoResponse: Decodable, Sendable {
    public let timestamp: String

    public var time: Date? {
        Timestamp.utc.date(from: timestamp)
    }
}

public struct RtspParamsResponse: Decodable, Sendable {
    public struct Item: Decodable, Sendable {
        public let description: String
        public let path: String
        public let port: String?
    }

    public let rtsp: Item
}
