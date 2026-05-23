# OneJpeg

Swift package for Next snapshot, video stream, and archive timestamp HTTP endpoints. Descriptors use [RequestResponse](https://github.com/avgx/RequestResponse); `AccessPoint` and `Timestamp` come from [OneWireFormat](https://github.com/avgx/OneWireFormat).

## Project layout

```
Sources/OneJpeg/
├── API/              SnapshotApi, StreamApi, TimestampApi
├── Media/            CropRect, RenderedInfoResponse, RtspParamsResponse
└── Internal/         headers, archive time formatting

Tests/OneJpegTests/
├── Resources/        JSON fixtures
└── OneJpegTests.swift
```

## Requirements

- Swift 6.1+
- iOS 15+, macOS 13+, tvOS 17+, visionOS 1+

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/avgx/OneJpeg", from: "1.0.0"),
],
targets: [
    .target(name: "MyApp", dependencies: ["OneJpeg"]),
]
```

## Quick start

```swift
import OneJpeg
import RequestResponse

let jpeg: Data = try await http.send(
    SnapshotApi.live(stream: "DEMOSERVER/DeviceIpint.1/SourceEndpoint.video:0:0", height: 480)
).value

let archive: Data = try await http.send(
    SnapshotApi.archive(stream: stream, time: date, height: 480)
).value

let mjpeg: Data = try await http.send(
    StreamApi.mjpegArchive(stream: stream, time: date, speed: 1)
).value

let rendered: RenderedInfoResponse = try await http.send(
    TimestampApi.renderedInfo(session: playbackSession)
).value
```

## HTTP API descriptors

| Enum | Method | Description |
|------|--------|-------------|
| `SnapshotApi` | `live(stream:height:)` | `GET live/media/snapshot/{stream}` |
| `SnapshotApi` | `archive(stream:time:height:crop:archive:)` | `GET archive/media/{stream}/{time}` |
| `SnapshotApi` | `mask(stream:time:archive:)` | `GET archive/contents/metadata/{stream}/{time}` |
| `StreamApi` | `mjpegLive(stream:height:session:)` | Live MJPEG |
| `StreamApi` | `mjpegArchive(stream:time:archive:height:speed:session:)` | Archive MJPEG |
| `StreamApi` | `fmp4Live(stream:keyFrames:session:)` | Live fMP4 |
| `StreamApi` | `fmp4Archive(stream:time:archive:speed:session:)` | Archive fMP4 |
| `StreamApi` | `rtspLiveLink(stream:)` | RTSP link JSON |
| `TimestampApi` | `sse(session:stream:)` | Archive timestamp SSE |
| `TimestampApi` | `sseLegacy(session:)` | Legacy SSE endpoint |
| `TimestampApi` | `renderedInfo(session:)` | Single rendered timestamp |

`stream` is a 3-segment `AccessPoint` (`HOST/Device/Endpoint`). Archive path time uses `Timestamp.utc`. Optional `archive` query value is e.g. `hosts/ARCHIVE-HOST`.

## Tests

```bash
swift test
```

## License

See [LICENSE](LICENSE).
