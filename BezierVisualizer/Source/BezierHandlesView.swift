import SwiftUI
import UIKit

struct BezierHandlesView: View {
  @Binding var points: Bezier.Points

  var body: some View {
    Text("Bezier Handles View")
  }
}

final class BezierHandlesView_: UIView {
  enum Action {
    case handleDidMove(Bezier.Point, CGPoint)
  }

  var perform: (Action) -> () = { _ in }

  private let p1View = HandleView()
  private let p2View = HandleView()
  private let c1View = HandleView()
  private let c2View = HandleView()

  init() {
    super.init(frame: .zero)

    addSubview(p1View)
    addSubview(p2View)
    addSubview(c1View)
    addSubview(c2View)

    p1View.didDrag = { [weak self] in self?.perform(.handleDidMove(.p1, $0)) }
    p2View.didDrag = { [weak self] in self?.perform(.handleDidMove(.p2, $0)) }
    c1View.didDrag = { [weak self] in self?.perform(.handleDidMove(.c1, $0)) }
    c2View.didDrag = { [weak self] in self?.perform(.handleDidMove(.c2, $0)) }
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setPoints(_ points: Bezier.Points) {
    p1View.position = points.p1
    p2View.position = points.p2
    c1View.position = points.c1
    c2View.position = points.c2
  }
}
