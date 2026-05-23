import Foundation
import OneWireFormat

/// Relative crop rectangle for archive snapshots (0…1 coordinates).
public struct CropRect: Sendable, Equatable {
    public let minX: Double
    public let minY: Double
    public let width: Double
    public let height: Double

    public init(minX: Double, minY: Double, width: Double, height: Double) {
        self.minX = minX
        self.minY = minY
        self.width = width
        self.height = height
    }
}
