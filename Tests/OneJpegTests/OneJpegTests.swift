import Foundation
import Testing
import OneWireFormat
@testable import OneJpeg

private let stream = "DEMOSERVER/DeviceIpint.1/SourceEndpoint.video:0:0"
private let archiveHost = "hosts/ARCHIVE-1"

@Test func snapshotLivePath() {
    let request = SnapshotApi.live(stream: stream, height: 240)
    #expect(request.path == "live/media/snapshot/\(stream)")
    #expect(request.headers?["Accept"] == "image/*")
    #expect(request.query?.contains(where: { $0.0 == "h" && $0.1 == "240" }) == true)
}

@Test func snapshotArchiveFormatsTimeInPath() {
    let time = Date(timeIntervalSince1970: 1_742_169_342.757638)
    let request = SnapshotApi.archive(stream: stream, time: time, height: 480, archive: archiveHost)
    let timeString = Timestamp.utc.string(from: time)
    #expect(request.path == "archive/media/\(stream)/\(timeString)")
    #expect(request.query?.contains(where: { $0.0 == "archive" && $0.1 == archiveHost }) == true)
}

@Test func snapshotArchiveCropQuery() {
    let time = Date(timeIntervalSince1970: 1_742_169_342)
    let crop = CropRect(minX: 0.1, minY: 0.2, width: 0.5, height: 0.4)
    let request = SnapshotApi.archive(stream: stream, time: time, height: 480, crop: crop)
    #expect(request.query?.contains(where: { $0.0 == "crop_x" && $0.1 == "0.1" }) == true)
    #expect(request.query?.contains(where: { $0.0 == "crop_height" && $0.1 == "0.4" }) == true)
}

@Test func mjpegArchiveUsesIntegerSpeed() {
    let session = UUID(uuidString: "00000000-0000-4000-8000-000000000099")!
    let time = Date(timeIntervalSince1970: 1_742_169_342)
    let request = StreamApi.mjpegArchive(
        stream: stream,
        time: time,
        archive: archiveHost,
        speed: 2.9,
        session: session
    )
    #expect(request.query?.contains(where: { $0.0 == "format" && $0.1 == "mjpeg" }) == true)
    #expect(request.query?.contains(where: { $0.0 == "speed" && $0.1 == "2" }) == true)
    #expect(request.path.contains(Timestamp.utc.string(from: time)))
}

@Test func fmp4LiveQuery() {
    let session = UUID(uuidString: "00000000-0000-4000-8000-000000000001")!
    let request = StreamApi.fmp4Live(stream: stream, keyFrames: true, session: session)
    #expect(request.path == "live/media/\(stream)")
    #expect(request.query?.contains(where: { $0.0 == "key_frames" && $0.1 == "1" }) == true)
}

@Test func timestampApiPaths() {
    let session = UUID(uuidString: "00000000-0000-4000-8000-000000000002")!
    #expect(TimestampApi.sse(session: session, stream: stream).path == "archive/media/\(stream)/time-on/\(session.uuidString)")
    #expect(TimestampApi.sseLegacy(session: session).path == "archive/media/time-on/\(session.uuidString)")
    #expect(TimestampApi.renderedInfo(session: session).path == "archive/media/rendered-info/\(session.uuidString)")
}

@Test func decodesRenderedInfo() throws {
    guard let url = Bundle.module.url(forResource: "rendered-info", withExtension: "json") else {
        throw NSError(domain: "Fixture", code: 1)
    }
    let response = try JSONDecoder().decode(RenderedInfoResponse.self, from: Data(contentsOf: url))
    #expect(response.timestamp == "20260403T123542.757638")
    #expect(response.time != nil)
}
