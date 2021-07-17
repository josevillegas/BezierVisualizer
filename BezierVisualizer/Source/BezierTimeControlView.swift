import SwiftUI
import UIKit

struct BezierTimeControlView: View {
  @State private var time = 0.0
  @State private var isOn = false

  var body: some View {
    HStack(spacing: 24) {
      Slider(value: $time) {}
        .disabled(!isOn)
        .id(isOn)
      Toggle(isOn: $isOn, label: { Text("") })
        .labelsHidden()
    }
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

  @objc private func sliderDidChange() {
    perform(.sliderDidChange(slider.value))
  }

  @objc private func switchDidChange() {
    perform(.switchDidChange(isOn: switchView.isOn))
  }
}
