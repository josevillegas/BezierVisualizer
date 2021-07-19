import SwiftUI
import UIKit

struct BezierTimeView: View {
  @Binding var points: Bezier.Points
  @Binding var time: CGFloat

  @State private var pointPosition: CGPoint = .zero

  init(points poimtsBinding: Binding<Bezier.Points>, time timeBinding: Binding<CGFloat>) {
    _points = poimtsBinding
    _time = timeBinding
    _pointPosition = State(initialValue: Bezier.TimePoints(points: points, time: time).timePoint)
  }

  var body: some View {
    ZStack {
      PointView()
        .position(pointPosition)
    }
      .onChange(of: time) { time in
        if time > 0 && time < 1 {
          pointPosition = Bezier.TimePoints(points: points, time: time).timePoint
        } else if time <= 0 {
          pointPosition = points.p1
        } else {
          pointPosition = points.p2
        }
      }
  }
}

struct PointView: View {
  var body: some View {
    Circle()
      .fill(Color(.sRGB, red: 0, green: 0.5, blue: 1, opacity: 1))
      .frame(width: 8, height: 8)
  }
}

final class BezierTimeView_: UIView {
  var time: CGFloat = 0 {
    didSet {
      if time < 0 { time = 0 }
      else if time > 1 { time = 1 }
      if oldValue == time { return }
      update()
    }
  }
  var points: Bezier.Points = .zero

  init() {
    super.init(frame: .zero)

    guard let layer = self.layer as? CAShapeLayer else { return }
    layer.fillColor = UIColor(white: 1, alpha: 0).cgColor
    layer.strokeColor = UIColor.lightGray.cgColor
    layer.lineWidth = 1
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func update() {
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
  }
}
