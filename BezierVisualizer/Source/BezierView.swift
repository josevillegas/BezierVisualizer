import SwiftUI

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

struct BezierPathView: View {
  @Binding var points: Bezier.Points

  var body: some View {
    let path = UIBezierPath()
    path.move(to: points.p1)
    path.addCurve(to: points.p2, controlPoint1: points.c1, controlPoint2: points.c2)
    return Path(path.cgPath)
      .stroke(Color.black, lineWidth: 1)
  }
}
