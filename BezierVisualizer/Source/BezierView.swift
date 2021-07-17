import UIKit

final class BezierView: UIView {
  private let pathView = BezierPathView()
  private let timeView = BezierTimeView()
  private let handlesView = BezierHandlesView()
  private let timeControlView = BezierTimeControlView()
  private let infoView = BezierInfoView()

  init() {
    super.init(frame: .zero)

    let stackView = UIStackView()
    let containerView = UIView()

    backgroundColor = .white
    stackView.axis = .vertical
    timeView.isHidden = true

    addSubview(stackView)

    containerView.addSubview(pathView)
    containerView.addSubview(timeView)
    containerView.addSubview(handlesView)

    stackView.addArrangedSubview(containerView)
    stackView.addArrangedSubview(timeControlView)
    stackView.addArrangedSubview(infoView)


    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
    stackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor).isActive = true
    stackView.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor).isActive = true
    stackView.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor).isActive = true

    pathView.translatesAutoresizingMaskIntoConstraints = false
    pathView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
    pathView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    pathView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
    pathView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true

    timeView.translatesAutoresizingMaskIntoConstraints = false
    timeView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
    timeView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    timeView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
    timeView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true

    handlesView.translatesAutoresizingMaskIntoConstraints = false
    handlesView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
    handlesView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    handlesView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
    handlesView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true

    handlesView.perform = { [weak self] in self?.update($0) }
    timeControlView.perform = { [weak self] in self?.update($0) }
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setPoints(_ points: Bezier.Points) {
    pathView.points = points
    timeView.points = points
    infoView.points = points
    handlesView.setPoints(points)
  }

  private func update(_ action: BezierHandlesView.Action) {
    switch action {
    case let .handleDidMove(point, value):
      pathView.points.setPoint(point, for: value)
      timeView.points.setPoint(point, for: value)
      infoView.points.setPoint(point, for: value)
    }
  }

  private func update(_ action: BezierTimeControlView.Action) {
    switch action {
    case let .sliderDidChange(value): timeView.time = CGFloat(value)
    case let .switchDidChange(isOn): timeView.isHidden = !isOn
    }
  }
}
