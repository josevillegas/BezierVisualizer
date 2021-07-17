import UIKit

final class BezierViewController: UIViewController {
  override func loadView() {
    let bezierView = BezierView()
    let points = Bezier.Points(
      p1: CGPoint(x: 100, y: 400),
      p2: CGPoint(x: 300, y: 400),
      c1: CGPoint(x: 100, y: 200),
      c2: CGPoint(x: 300, y: 200)
    )
    bezierView.setPoints(points)
    view = bezierView
  }
}
