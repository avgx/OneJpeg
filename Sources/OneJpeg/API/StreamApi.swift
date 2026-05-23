import Foundation
import OneWireFormat
import RequestResponse

public enum StreamApi {
    public static func mjpegLive(
        stream: AccessPoint,
        height: Int = 480,
        session: UUID = UUID()
    ) -> Request<Data> {
        let query: [(String, String?)] = [
            ("format", "mjpeg"),
            ("w", "0"),
            ("h", String(height)),
            ("id", session.uuidString),
        ]
        return Request(
            path: "live/media/\(stream.nohosts)",
            method: .get,
            query: query,
            headers: MediaHeaders.acceptAll
        )
    }

    public static func mjpegArchive(
        stream: AccessPoint,
        time: Date,
        archive: String? = nil,
        height: Int = 480,
        speed: Double = 1.0,
        session: UUID = UUID()
    ) -> Request<Data> {
        var query: [(String, String?)] = [
            ("format", "mjpeg"),
            ("w", "0"),
            ("h", String(height)),
            ("speed", String(Int(speed))),
            ("id", session.uuidString),
        ]

        if let archive {
            query.append(("archive", archive))
        }

        let timeString = archiveTimeString(from: time)
        return Request(
            path: "archive/media/\(stream.nohosts)/\(timeString)",
            method: .get,
            query: query,
            headers: MediaHeaders.acceptAll
        )
    }

    public static func fmp4Live(
        stream: AccessPoint,
        keyFrames: Bool = false,
        session: UUID = UUID()
    ) -> Request<Data> {
        let query: [(String, String?)] = [
            ("format", "mp4"),
            ("key_frames", keyFrames ? "1" : "0"),
            ("id", session.uuidString),
        ]
        return Request(
            path: "live/media/\(stream.nohosts)",
            method: .get,
            query: query,
            headers: MediaHeaders.acceptAll
        )
    }

    public static func fmp4Archive(
        stream: AccessPoint,
        time: Date,
        archive: String? = nil,
        speed: Double = 1.0,
        session: UUID = UUID()
    ) -> Request<Data> {
        var query: [(String, String?)] = [
            ("format", "mp4"),
            ("speed", String(Int(speed))),
            ("id", session.uuidString),
        ]

        if let archive {
            query.append(("archive", archive))
        }

        let timeString = archiveTimeString(from: time)
        return Request(
            path: "archive/media/\(stream.nohosts)/\(timeString)",
            method: .get,
            query: query,
            headers: MediaHeaders.acceptAll
        )
    }

    public static func rtspLiveLink(stream: AccessPoint) -> Request<RtspParamsResponse> {
        let query: [(String, String?)] = [
            ("format", "rtsp"),
        ]
        return Request(
            path: "live/media/\(stream.nohosts)",
            method: .get,
            query: query
        )
    }
}
