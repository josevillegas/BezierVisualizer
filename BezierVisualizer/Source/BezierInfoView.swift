import SwiftUI

struct BezierInfoView: View {
  @Binding var points: Bezier.Points

  private let formatter = BezierInfoFormatter()

  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      InfoRowView(title: "P1", value: formatter.format(points.p1))
      InfoRowView(title: "P2", value: formatter.format(points.p2))
      InfoRowView(title: "C1", value: formatter.format(points.c1))
      InfoRowView(title: "C2", value: formatter.format(points.c2))
      InfoRowView(title: "L", value: formatter.format(Bezier.length(points: points, intervals: 2)))
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
    formatter.maximumFractionDigits = 2
  }

  func format(_ point: CGPoint) -> String {
    "(\(formatter.string(for: point.x) ?? "0"), \(formatter.string(for: point.y) ?? "0"))"
  }

  func format(_ value: CGFloat) -> String {
    "\(formatter.string(for: value) ?? "0")"
  }
}
