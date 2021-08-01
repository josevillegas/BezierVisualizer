import SwiftUI

struct BezierView: View {
  @Binding var bezierValues: Bezier.Values
  @Binding var isTimeViewVisible: Bool
  @Binding var initialPathViewSize: CGSize

  var body: some View {
    GeometryReader { geometry in
      ZStack {
        Path(path)
          .stroke(Color.black, lineWidth: 1)
        if isTimeViewVisible {
          BezierTimeView(bezierValues: $bezierValues)
        }
        ZStack {
          HandleView(dragPosition: $bezierValues.points.p1)
          HandleView(dragPosition: $bezierValues.points.p2)
          HandleView(dragPosition: $bezierValues.points.c1)
          HandleView(dragPosition: $bezierValues.points.c2)
        }
      }
        .onAppear {
          if initialPathViewSize == .zero {
            initialPathViewSize = geometry.size
          }
        }
    }
  }

  var path: CGPath {
    let points = bezierValues.points
    let path = UIBezierPath()
    path.move(to: points.p1)
    path.addCurve(to: points.p2, controlPoint1: points.c1, controlPoint2: points.c2)
    return path.cgPath
  }
}

struct HandleView: View {
  @Binding var dragPosition: CGPoint

  var body: some View {
    ZStack {
      Circle()
        .fill(Color.white)
      Circle()
        .stroke(Color.red, lineWidth: 2)
    }
      .frame(width: 10, height: 10)
      .padding(17)
      .draggable(position: $dragPosition)
  }
}
