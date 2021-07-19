import SwiftUI

struct BezierView: View {
  @Binding var bezierValues: Bezier.Values
  @Binding var isTimeViewVisible: Bool
  @Binding var pathViewSize: CGSize

  var body: some View {
    GeometryReader { geometry in
      ZStack {
        BezierPathView(points: $bezierValues.points)
        if isTimeViewVisible {
          BezierTimeView(bezierValues: $bezierValues)
        }
        BezierHandlesView(points: $bezierValues.points)
      }
        .onAppear {
          if pathViewSize == .zero {
            pathViewSize = geometry.size
          }
        }
    }
  }
}

struct BezierPathView: View {
  @Binding var points: Bezier.Points

  var body: some View {
    Path(path)
      .stroke(Color.black, lineWidth: 1)
  }

  var path: CGPath {
    let path = UIBezierPath()
    path.move(to: points.p1)
    path.addCurve(to: points.p2, controlPoint1: points.c1, controlPoint2: points.c2)
    return path.cgPath
  }
}
