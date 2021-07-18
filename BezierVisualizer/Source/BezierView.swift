import SwiftUI
import UIKit

struct BezierVisualizerView: View {
  @State private var isTimeViewVisible = false
  @State private var time: Float = 0

  @State private var points = Bezier.Points(
    p1: CGPoint(x: 100, y: 400),
    p2: CGPoint(x: 300, y: 400),
    c1: CGPoint(x: 100, y: 200),
    c2: CGPoint(x: 300, y: 200)
  )

  var body: some View {
    VStack(spacing: 0) {
      BezierView(points: $points, time: $time, isTimeViewVisible: $isTimeViewVisible)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      Divider()
      BezierControlsView(points: $points, time: $time, isToggleOn: $isTimeViewVisible)
        .padding(EdgeInsets(top: 12, leading: 24, bottom: 0, trailing: 24))
    }
  }
}

struct BezierView: View {
  @Binding var points: Bezier.Points
  @Binding var time: Float
  @Binding var isTimeViewVisible: Bool

  var body: some View {
    ZStack {
      BezierPathView(points: $points)
      if isTimeViewVisible {
        BezierTimeView(points: $points, time: $time)
      }
      BezierHandlesView(points: $points)
    }
  }
}

struct BezierControlsView: View {
  @Binding var points: Bezier.Points
  @Binding var time: Float
  @Binding var isToggleOn: Bool

  var body: some View {
    VStack(spacing: 16) {
      HStack(spacing: 24) {
        Slider(value: $time) {}
          .disabled(!isToggleOn)
          .id(isToggleOn)
        Toggle(isOn: $isToggleOn, label: { Text("") })
          .labelsHidden()
      }
      HStack {
        BezierInfoView(points: $points)
        Spacer()
      }
    }
  }
}

final class BezierView_ {
  private let pathView = BezierPathView_()
  private let timeView = BezierTimeView_()
  private let handlesView = BezierHandlesView_()
  private let infoView = BezierInfoView_()

  init() {
    handlesView.perform = { [weak self] in self?.update($0) }
  }

  private func update(_ action: BezierHandlesView_.Action) {
    switch action {
    case let .handleDidMove(point, value):
      pathView.points.setPoint(point, for: value)
      timeView.points.setPoint(point, for: value)
      infoView.points.setPoint(point, for: value)
    }
  }
}
