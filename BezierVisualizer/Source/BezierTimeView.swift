import SwiftUI

struct BezierTimeView: View {
  @Binding var bezierValues: Bezier.Values
  @State private var pointPosition: CGPoint = .zero

  init(bezierValues bezierValuesBinding: Binding<Bezier.Values>) {
    _bezierValues = bezierValuesBinding
    _pointPosition = State(initialValue: Bezier.TimePoints(points: bezierValues.points, time: bezierValues.time).timePoint)
  }

  var body: some View {
    ZStack {
      BezierTimePathView(bezierValues: $bezierValues)
      PointView()
        .position(pointPosition)
    }
      .onChange(of: bezierValues.time) { time in
        pointPosition = Bezier.TimePoints(points: bezierValues.points, time: bezierValues.time).timePoint
      }
  }
}

struct BezierTimePathView: View {
  @Binding var bezierValues: Bezier.Values

  var body: some View {
    Path(path)
      .stroke(Color(UIColor.black.withAlphaComponent(0.3)), lineWidth: 1)
  }

  var path: CGPath {
    let points = bezierValues.points
    let time = bezierValues.time
    let path = UIBezierPath()
    path.move(to: points.p1)
    path.addLine(to: points.c1)
    path.addLine(to: points.c2)
    path.addLine(to: points.p2)
    if time > 0 && time < 1 {
      let timePoints = Bezier.TimePoints(points: points, time: time)
      path.move(to: timePoints.p1c1)
      path.addLine(to: timePoints.c1c2)
      path.addLine(to: timePoints.c2p2)
      path.move(to: timePoints.p1c1c2)
      path.addLine(to: timePoints.c1c2p2)
    }
    return path.cgPath
  }
}

struct PointView: View {
  var body: some View {
    Circle()
      .fill(Color(.sRGB, red: 0, green: 0.5, blue: 1, opacity: 1))
      .frame(width: 8, height: 8)
  }
}
