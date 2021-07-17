import UIKit

final class HandleView: UIView {
  var didDrag: (CGPoint) -> () = { _ in }
  var position: CGPoint {
    get { return frame.origin }
    set { frame = CGRect(origin: newValue, size: .zero) }
  }

  private let layerFrame: CGRect
  private var dragOrigin: CGPoint?

  init() {
    let size: CGFloat = 10
    layerFrame = CGRect(x: -size / 2, y: -size / 2, width: size, height: size)
    super.init(frame: .zero)

    clipsToBounds = false

    let sublayer = CALayer()
    sublayer.frame = layerFrame
    sublayer.backgroundColor = UIColor.white.cgColor
    sublayer.borderColor = UIColor.red.cgColor
    sublayer.borderWidth = 2
    sublayer.cornerRadius = size / 2

    layer.addSublayer(sublayer)

    let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragged))
    addGestureRecognizer(gestureRecognizer)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    return CGRect(x: -22, y: -22, width: 44, height: 44).contains(point)
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
