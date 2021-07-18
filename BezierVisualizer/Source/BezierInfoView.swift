import SwiftUI
import UIKit

struct BezierInfoView: View {
  @Binding var points: Bezier.Points

  @State private var p1: String = ""
  @State private var p2: String = ""
  @State private var c1: String = ""
  @State private var c2: String = ""
  @State private var l: String = ""

  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      InfoRowView(title: "P1", value: $p1)
      InfoRowView(title: "P2", value: $p2)
      InfoRowView(title: "C1", value: $c1)
      InfoRowView(title: "C2", value: $c2)
      InfoRowView(title: "L", value: $l)
    }
  }
}

struct InfoRowView: View {
  let title: String
  @Binding var value: String

  var body: some View {
    HStack(spacing: 12) {
      Text(title)
      Text(value)
    }
  }
}

final class BezierInfoView_: UIView {
  var points: Bezier.Points = .zero {
    didSet { update() }
  }

  private func update() {
//    p1Label.setValue(with: points.p1)
//    p2Label.setValue(with: points.p2)
//    c1Label.setValue(with: points.c1)
//    c2Label.setValue(with: points.c2)
//    lengthLabel.setValue(with: Bezier.length(points: points, intervals: 2))
  }
}

private final class BezierInfoRow: UIStackView {
  private let valueLabel = UILabel()
  private let formatter = NumberFormatter()
  //formatter.maximumFractionDigits = 2

  func setValue(with point: CGPoint) {
    valueLabel.text = "(\(formatter.string(for: point.x) ?? "0"), \(formatter.string(for: point.y) ?? "0"))"
  }

  func setValue(with value: CGFloat) {
    valueLabel.text = "\(formatter.string(for: value) ?? "0")"
  }
}
