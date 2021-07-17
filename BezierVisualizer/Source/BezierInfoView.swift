import SwiftUI
import UIKit

struct BezierInfoView: View {
  var body: some View {
    VStack(alignment: .leading) {
      InfoRowView(title: "P1")
      InfoRowView(title: "P2")
      InfoRowView(title: "C1")
      InfoRowView(title: "C2")
      InfoRowView(title: "L")
    }
  }
}

struct InfoRowView: View {
  let title: String

  var body: some View {
    Text(title)
  }
}

final class BezierInfoView_: UIView {
  var points: Bezier.Points = .zero {
    didSet { update() }
  }

  private let p1Label = BezierInfoRow(title: "P1")
  private let p2Label = BezierInfoRow(title: "P2")
  private let c1Label = BezierInfoRow(title: "C1")
  private let c2Label = BezierInfoRow(title: "C2")
  private let lengthLabel = BezierInfoRow(title: "L")

  init() {
    super.init(frame: .zero)

    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 6

    addSubview(stackView)
    stackView.addArrangedSubview(p1Label)
    stackView.addArrangedSubview(p2Label)
    stackView.addArrangedSubview(c1Label)
    stackView.addArrangedSubview(c2Label)
    stackView.addArrangedSubview(lengthLabel)

    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
    stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
    stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
    stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func update() {
    p1Label.setValue(with: points.p1)
    p2Label.setValue(with: points.p2)
    c1Label.setValue(with: points.c1)
    c2Label.setValue(with: points.c2)
    lengthLabel.setValue(with: Bezier.length(points: points, intervals: 2))
  }
}

private final class BezierInfoRow: UIStackView {
  private let valueLabel = UILabel()
  private let formatter = NumberFormatter()

  init(title: String) {
    super.init(frame: .zero)

    spacing = 12

    let titleLabel = UILabel()
    titleLabel.text = title
    titleLabel.setContentHuggingPriority(.required, for: .horizontal)
    titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

    addArrangedSubview(titleLabel)
    addArrangedSubview(valueLabel)

    formatter.maximumFractionDigits = 2
  }

  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setValue(with point: CGPoint) {
    valueLabel.text = "(\(formatter.string(for: point.x) ?? "0"), \(formatter.string(for: point.y) ?? "0"))"
  }

  func setValue(with value: CGFloat) {
    valueLabel.text = "\(formatter.string(for: value) ?? "0")"
  }
}
