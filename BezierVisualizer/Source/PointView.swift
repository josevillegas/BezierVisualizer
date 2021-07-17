import UIKit

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
