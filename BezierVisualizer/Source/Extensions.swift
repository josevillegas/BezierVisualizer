import CoreGraphics
import Foundation

extension FloatingPoint {
  func clampedToOne() -> Self {
    max(0, min(1, self))
  }
}

struct BezierFormatter {
  private let formatter = NumberFormatter()

  init() {
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
  }

  func format(_ point: CGPoint) -> String {
    "(\(format(point.x)), \(format(point.y)))"
  }

  func format(_ value: CGFloat) -> String {
    "\(formatter.string(for: value) ?? "0")"
  }
}
