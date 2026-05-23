import Foundation
import OneWireFormat
import RequestResponse

public enum TimestampApi {
    /// Archive playback timestamps via SSE (preferred).
    public static func sse(session: UUID, stream: AccessPoint) -> Request<Data> {
        Request(path: "archive/media/\(stream.nohosts)/time-on/\(session.uuidString)")
    }

    /// Legacy SSE endpoint when `sse` is unavailable.
    public static func sseLegacy(session: UUID) -> Request<Data> {
        Request(path: "archive/media/time-on/\(session.uuidString)")
    }

    /// Single rendered-frame timestamp for archive playback sync.
    public static func renderedInfo(session: UUID) -> Request<RenderedInfoResponse> {
        let query: [(String, String?)] = [
            ("_", String(Date().timeIntervalSince1970)),
        ]
        return Request(
            path: "archive/media/rendered-info/\(session.uuidString)",
            method: .get,
            query: query
        )
    }
}
