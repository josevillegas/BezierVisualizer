import SwiftUI
import UIKit

struct BezierTimeView: View {
  @Binding var points: Bezier.Points
  @Binding var time: CGFloat

  @State private var pointPosition: CGPoint = .zero

  init(points poimtsBinding: Binding<Bezier.Points>, time timeBinding: Binding<CGFloat>) {
    _points = poimtsBinding
    _time = timeBinding
    let timePoints = points.timePoints(time: time)
    _pointPosition = State(initialValue: Bezier.point(t: time, p1: timePoints.p21, p2: timePoints.p22))
  }

  var body: some View {
    ZStack {
      PointView()
        .position(pointPosition)
    }
      .onChange(of: time) { time in
        if time > 0 && time < 1 {
          let timePoints = points.timePoints(time: time)
          pointPosition = timePoints.p3
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
  var points: Bezier.Points = .zero {
    didSet { update() }
  }

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

    let p1 = points.p1
    let p2 = points.p2
    let c1 = points.c1
    let c2 = points.c2

    path.move(to: p1)
    path.addLine(to: c1)
    path.addLine(to: c2)
    path.addLine(to: p2)

    if time > 0 && time < 1 {
      let p11 = Bezier.point(t: time, p1: p1, p2: c1)
      let p12 = Bezier.point(t: time, p1: c1, p2: c2)
      let p13 = Bezier.point(t: time, p1: c2, p2: p2)
      path.move(to: p11)
      path.addLine(to: p12)
      path.addLine(to: p13)

      let p21 = Bezier.point(t: time, p1: p11, p2: p12)
      let p22 = Bezier.point(t: time, p1: p12, p2: p13)
      path.move(to: p21)
      path.addLine(to: p22)
    }
  }
}
