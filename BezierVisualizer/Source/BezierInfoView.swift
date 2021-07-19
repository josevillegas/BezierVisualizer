import SwiftUI

struct BezierInfoView: View {
  @Binding var points: Bezier.Points

  private let formatter = BezierInfoFormatter()

  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      InfoRowView(title: "point 1:", value: formatter.format(points.p1))
      InfoRowView(title: "point 2:", value: formatter.format(points.p2))
      InfoRowView(title: "control 1:", value: formatter.format(points.c1))
      InfoRowView(title: "control 2:", value: formatter.format(points.c2))
      InfoRowView(title: "length:", value: formatter.format(Bezier.length(points: points, intervals: 2)))
    }
  }
}

struct InfoRowView: View {
  let title: String
  let value: String

  var body: some View {
    HStack(spacing: 12) {
      Text(title)
      Text(value)
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
