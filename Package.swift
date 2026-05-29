// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "OneJpeg",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15),
        .macOS(.v13),
        .tvOS(.v17),
        .visionOS(.v1),
    ],
    products: [
        .library(name: "OneJpeg", targets: ["OneJpeg"]),
    ],
    dependencies: [
        .package(url: "https://github.com/avgx/OneWireFormat", from: "1.0.2"),
        .package(url: "https://github.com/avgx/RequestResponse", from: "2.0.0"),
    ],
    targets: [
        .target(
            name: "OneJpeg",
            dependencies: [
                .product(name: "OneWireFormat", package: "OneWireFormat"),
                .product(name: "RequestResponse", package: "RequestResponse"),
            ]
        ),
        .testTarget(
            name: "OneJpegTests",
            dependencies: ["OneJpeg"],
            resources: [
                .process("Resources"),
            ]
        ),
    ]
)
