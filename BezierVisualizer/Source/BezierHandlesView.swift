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
  @State private var lastOffset: CGSize = .zero
  @State private var dragOffset: CGSize = .zero

  var body: some View {
    let gesture = DragGesture()
    .onChanged { gesture in
      dragOffset = CGSize(
        width: lastOffset.width + gesture.translation.width,
        height: lastOffset.height + gesture.translation.height
      )
    }
    .onEnded { gesture in
      lastOffset = dragOffset
    }
    ZStack {
      Circle()
        .fill(Color.white)
      Circle()
        .stroke(Color.red, lineWidth: 2)
    }
      .frame(width: 10, height: 10)
      .padding(17)
      .offset(dragOffset)
      .gesture(gesture)
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
}
