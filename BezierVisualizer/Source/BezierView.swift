import SwiftUI
import UIKit

struct BezierVisualizerView: View {
  var body: some View {
    VStack(spacing: 0) {
      BezierView()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      Divider()
      BezierControlsView()
        .padding(EdgeInsets(top: 12, leading: 24, bottom: 0, trailing: 24))
    }
  }
}

struct BezierView: View {
  var body: some View {
    Group {
      BezierPathView()
      BezierTimeView()
      BezierHandlesView()
    }
  }
}

struct BezierControlsView: View {
  var body: some View {
    VStack(spacing: 16) {
      BezierTimeControlView()
      HStack {
        BezierInfoView()
        Spacer()
      }
    }
  }
}

final class BezierViewController: UIViewController {
  override func loadView() {
    let bezierView = BezierView_()
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

final class BezierView_: UIView {
  private let pathView = BezierPathView_()
  private let timeView = BezierTimeView_()
  private let handlesView = BezierHandlesView_()
  private let timeControlView = BezierTimeControlView_()
  private let infoView = BezierInfoView_()

  init() {
    super.init(frame: .zero)

    timeView.isHidden = true

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

  private func update(_ action: BezierHandlesView_.Action) {
    switch action {
    case let .handleDidMove(point, value):
      pathView.points.setPoint(point, for: value)
      timeView.points.setPoint(point, for: value)
      infoView.points.setPoint(point, for: value)
    }
  }

  private func update(_ action: BezierTimeControlView_.Action) {
    switch action {
    case let .sliderDidChange(value): timeView.time = CGFloat(value)
    case let .switchDidChange(isOn): timeView.isHidden = !isOn
    }
  }
}
