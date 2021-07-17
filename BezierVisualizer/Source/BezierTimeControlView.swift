import SwiftUI
import UIKit

struct BezierTimeControlView: View {
  var body: some View {
    Text("Bezier Time Control View")
  }
}

final class BezierTimeControlView_: UIView {
  enum Action {
    case sliderDidChange(Float)
    case switchDidChange(isOn: Bool)
  }

  private let slider = UISlider()
  private let switchView = UISwitch()

  var perform: (Action) -> () = { _ in }

  init() {
    super.init(frame: .zero)

    let stackView = UIStackView()
    stackView.spacing = 24

    slider.isEnabled = false

    addSubview(stackView)
    stackView.addArrangedSubview(slider)
    stackView.addArrangedSubview(switchView)

    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
    stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
    stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
    stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true

    slider.addTarget(self, action: #selector(sliderDidChange), for: .valueChanged)
    switchView.addTarget(self, action: #selector(switchDidChange), for: .valueChanged)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  @objc private func sliderDidChange() {
    perform(.sliderDidChange(slider.value))
  }

  @objc private func switchDidChange() {
    slider.isEnabled = switchView.isOn
    perform(.switchDidChange(isOn: switchView.isOn))
  }
}
