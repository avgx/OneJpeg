import Foundation
import OneWireFormat
import RequestResponse

public enum SnapshotApi {
    public static func live(stream: AccessPoint, height: Int) -> Request<Data> {
        let query: [(String, String?)] = [
            ("w", "0"),
            ("h", String(height)),
            ("_", noCacheToken()),
        ]
        return Request(
            path: "live/media/snapshot/\(stream.nohosts)",
            method: .get,
            query: query,
            headers: MediaHeaders.acceptImage
        )
    }

    public static func archive(
        stream: AccessPoint,
        time: Date,
        height: Int,
        crop: CropRect? = nil,
        archive: String? = nil
    ) -> Request<Data> {
        var query: [(String, String?)] = [
            ("w", "0"),
            ("h", String(height)),
        ]

        if let crop {
            query.append(("crop_x", String(crop.minX)))
            query.append(("crop_y", String(crop.minY)))
            query.append(("crop_width", String(crop.width)))
            query.append(("crop_height", String(crop.height)))
        }

        if let archive {
            query.append(("archive", archive))
        }

        let timeString = archiveTimeString(from: time)
        return Request(
            path: "archive/media/\(stream.nohosts)/\(timeString)",
            method: .get,
            query: query,
            headers: MediaHeaders.acceptImage
        )
    }

    public static func mask(
        stream: AccessPoint,
        time: Date,
        archive: String? = nil
    ) -> Request<Data> {
        var query: [(String, String?)] = []

        if let archive {
            query.append(("archive", archive))
        }

        let timeString = archiveTimeString(from: time)
        return Request(
            path: "archive/contents/metadata/\(stream.nohosts)/\(timeString)",
            method: .get,
            query: query.isEmpty ? nil : query
        )
    }
}
