import SwiftUI

struct BezierView: View {
  @Binding var points: Bezier.Points
  @Binding var time: Float
  @Binding var isTimeViewVisible: Bool
  @Binding var pathViewSize: CGSize

  var body: some View {
    GeometryReader { geometry in
      ZStack {
        BezierPathView(points: $points)
        if isTimeViewVisible {
          BezierTimeView(points: $points, time: $time)
        }
        BezierHandlesView(points: $points)
      }
        .onAppear {
          if pathViewSize == .zero {
            pathViewSize = geometry.size
          }
        }
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
      .padding(EdgeInsets(top: 12, leading: 24, bottom: 0, trailing: 24))
      .background(Color(UIColor.systemBackground))
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
