import SwiftUI

struct BezierInfoView: View {
  @Binding var points: Bezier.Points

  private let formatter = BezierInfoFormatter()
  private let labels = ["point 1", "point 2", "control 1", "control 2", "length"]

  var body: some View {
    HStack(spacing: 18) {
      VStack(alignment: .leading, spacing: 6) {
        ForEach(labels, id: \.self) { Text($0 + ":") }
      }
      VStack(alignment: .leading, spacing: 6) {
        Text(formatter.format(points.p1))
        Text(formatter.format(points.p2))
        Text(formatter.format(points.c1))
        Text(formatter.format(points.c2))
        Text(formatter.format(Bezier.length(points: points, intervals: 2)))
      }
    }
  }
}

struct BezierInfoFormatter {
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
