import SwiftUI
import UIKit

struct BezierTimeControlView: View {
  @Binding var isToggleOn: Bool

  @State private var time = 0.0

  var body: some View {
    HStack(spacing: 24) {
      Slider(value: $time) {}
        .disabled(!isToggleOn)
        .id(isToggleOn)
      Toggle(isOn: $isToggleOn, label: { Text("") })
        .labelsHidden()
    }
  }
}

final class BezierTimeControlView_: UIView {
  enum Action {
    case sliderDidChange(Float)
  }

  var perform: (Action) -> () = { _ in }

  @objc private func sliderDidChange() {
//    perform(.sliderDidChange(slider.value))
  }
}
