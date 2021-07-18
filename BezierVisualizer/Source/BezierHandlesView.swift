import SwiftUI
import UIKit

struct BezierHandlesView: View {
  @Binding var points: Bezier.Points

  var body: some View {
    ZStack {
      HandleView()
        .position(points.p1)
      HandleView()
        .position(points.p2)
      HandleView()
        .position(points.c1)
      HandleView()
        .position(points.c2)
    }
  }
}

struct HandleView: View {
  var body: some View {
    Circle()
      .stroke(Color.red, lineWidth: 2)
      .frame(width: 10, height: 10)
      .padding(17)
  }
}

final class BezierHandlesView_: UIView {
  enum Action {
    case handleDidMove(Bezier.Point, CGPoint)
  }

  var perform: (Action) -> () = { _ in }

  private let p1View = HandleView_()
  private let p2View = HandleView_()
  private let c1View = HandleView_()
  private let c2View = HandleView_()

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

final class HandleView_: UIView {
  var didDrag: (CGPoint) -> () = { _ in }
  var position: CGPoint {
    get { frame.origin }
    set { frame = CGRect(origin: newValue, size: .zero) }
  }

  private let layerFrame: CGRect
  private var dragOrigin: CGPoint?

  init() {
    let size: CGFloat = 10
    layerFrame = CGRect(x: -size / 2, y: -size / 2, width: size, height: size)
    super.init(frame: .zero)

    let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragged))
    addGestureRecognizer(gestureRecognizer)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  @objc private func dragged(_ recognizer: UIPanGestureRecognizer) {
    switch recognizer.state {
    case .possible: break
    case .began: dragOrigin = frame.origin
    case .changed:
      guard let dragOrigin = dragOrigin, let superview = superview else { break }
      let translation = recognizer.translation(in: superview)
      frame = CGRect(origin: CGPoint(x: dragOrigin.x + translation.x, y: dragOrigin.y + translation.y), size: .zero)
      didDrag(position)
    case .ended,
         .cancelled,
         .failed:
      dragOrigin = nil
    @unknown default: fatalError()
    }
  }
}
