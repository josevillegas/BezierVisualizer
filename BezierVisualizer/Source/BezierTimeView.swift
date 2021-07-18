import SwiftUI
import UIKit

struct BezierTimeView: View {
  @Binding var points: Bezier.Points
  @Binding var time: Float

  var body: some View {
    Text("Time: \(time)")
  }
}

final class BezierTimeView_: UIView {
  override class var layerClass: AnyClass {
    CAShapeLayer.self
  }

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

  private let pointView = PointView()

  init() {
    super.init(frame: .zero)

    addSubview(pointView)

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

      pointView.position = Bezier.point(t: time, p1: p21, p2: p22)
    } else if time <= 0 {
      pointView.position = p1
    } else {
      pointView.position = p2
    }

    guard let layer = self.layer as? CAShapeLayer else { return }
    layer.path = path.cgPath
  }
}

final class PointView: UIView {
  var position: CGPoint {
    get { frame.origin }
    set { frame = CGRect(origin: newValue, size: .zero) }
  }

  init() {
    super.init(frame: .zero)

    clipsToBounds = false

    let size: CGFloat = 8
    let sublayer = CALayer()
    sublayer.frame = CGRect(x: -size / 2, y: -size / 2, width: size, height: size)
    sublayer.backgroundColor = UIColor(red: 0, green: 0.5, blue: 1, alpha: 1).cgColor
    sublayer.cornerRadius = size / 2

    layer.addSublayer(sublayer)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
