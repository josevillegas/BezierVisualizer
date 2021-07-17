import UIKit

final class BezierPathView: UIView {
  override class var layerClass: AnyClass {
    return CAShapeLayer.self
  }

  var points: Bezier.Points = .zero {
    didSet { update() }
  }

  init() {
    super.init(frame: .zero)

    guard let layer = self.layer as? CAShapeLayer else { return }
    layer.fillColor = UIColor(white: 1, alpha: 0).cgColor
    layer.strokeColor = UIColor.black.cgColor
    layer.lineWidth = 1
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func update() {
    guard let layer = self.layer as? CAShapeLayer else { return }
    let path = UIBezierPath()
    path.move(to: points.p1)
    path.addCurve(to: points.p2, controlPoint1: points.c1, controlPoint2: points.c2)
    layer.path = path.cgPath
  }
}
