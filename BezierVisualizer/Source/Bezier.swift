import CoreGraphics

enum Bezier {
  struct Values: Equatable {
    var points: Points
    var time: CGFloat
  }

  enum Point {
    case p1
    case p2
    case c1
    case c2
  }

  struct Points: Equatable {
    var p1: CGPoint
    var p2: CGPoint
    var c1: CGPoint
    var c2: CGPoint
  }

  struct TimePoints {
    var p1c1: CGPoint
    var c1c2: CGPoint
    var c2p2: CGPoint
    var p1c1c2: CGPoint
    var c1c2p2: CGPoint
    var timePoint: CGPoint
  }
}

extension Bezier.Values {
  static var zero: Bezier.Values {
    Bezier.Values(points: .zero, time: 0)
  }
}

extension Bezier.Points {
  static var zero: Bezier.Points {
    Bezier.Points(p1: .zero, p2: .zero, c1: .zero, c2: .zero)
  }

  mutating func setPoint(_ point: Bezier.Point, for value: CGPoint) {
    switch point {
    case .p1: p1 = value
    case .p2: p2 = value
    case .c1: c1 = value
    case .c2: c2 = value
    }
  }

  static func square(in size: CGSize, ratio: CGFloat = 0.5) -> Bezier.Points {
    points(
      center: CGPoint(x: size.width / 2, y: size.height / 2),
      apothem: min(size.width, size.height) * ratio / 2
    )
  }

  static func points(center: CGPoint, apothem: CGFloat) -> Bezier.Points {
    Bezier.Points(
      p1: CGPoint(x: center.x - apothem, y: center.y + apothem),
      p2: CGPoint(x: center.x + apothem, y: center.y + apothem),
      c1: CGPoint(x: center.x - apothem, y: center.y - apothem),
      c2: CGPoint(x: center.x + apothem, y: center.y - apothem)
    )
  }
}

extension Bezier.TimePoints {
  init(points: Bezier.Points, time: CGFloat) {
    let time = time.clampedToOne()
    let p1c1 = Bezier.point(t: time, p1: points.p1, p2: points.c1)
    let c1c2 = Bezier.point(t: time, p1: points.c1, p2: points.c2)
    let c2p2 = Bezier.point(t: time, p1: points.c2, p2: points.p2)
    let p1c1c2 = Bezier.point(t: time, p1: p1c1, p2: c1c2)
    let c1c2p2 = Bezier.point(t: time, p1: c1c2, p2: c2p2)
    let timePoint = Bezier.point(t: time, p1: p1c1c2, p2: c1c2p2)
    self.init(p1c1: p1c1, c1c2: c1c2, c2p2: c2p2, p1c1c2: p1c1c2, c1c2p2: c1c2p2, timePoint: timePoint)
  }
}

extension Bezier {
  /// Returns the point between p1 and p2 at time t.
  static func point(t: CGFloat, p1: CGPoint, p2: CGPoint) -> CGPoint {
    point(clamped: t.clampedToOne(), p1: p1, p2: p2)
  }

  static private func point(clamped t: CGFloat, p1: CGPoint, p2: CGPoint) -> CGPoint {
    CGPoint(
      x: p1.x + t * (p2.x - p1.x),
      y: p1.y + t * (p2.y - p1.y)
    )
  }

  /// Returns the bezier point at time t.
  static func point(t: CGFloat, p1: CGPoint, p2: CGPoint, c1: CGPoint, c2: CGPoint) -> CGPoint {
    point(clamped: t.clampedToOne(), p1: p1, p2: p2, c1: c1, c2: c2)
  }

  static private func point(clamped t: CGFloat, p1: CGPoint, p2: CGPoint, c1: CGPoint, c2: CGPoint) -> CGPoint {
    point(clamped: t, t2: pow(t, 2), t3:  pow(t, 3), p1: p1, p2: p2, c1: c1, c2: c2)
  }

  /// t2 and t3 are precalculated values for t^2 and t^3.
  static private func point(clamped t: CGFloat, t2: CGFloat, t3: CGFloat, p1: CGPoint, p2: CGPoint, c1: CGPoint, c2: CGPoint) -> CGPoint {
    CGPoint(
      x: point(clamped: t, t2: t2, t3: t3, p1: p1.x, p2: p2.x, c1: c1.x, c2: c2.x),
      y: point(clamped: t, t2: t2, t3: t3, p1: p1.y, p2: p2.y, c1: c1.y, c2: c2.y)
    )
  }

  /// Returns the bezier point at time t for a given axis.
  /// t2 and t3 are precalculated values for t² and t³.
  static private func point(clamped t: CGFloat, t2: CGFloat, t3: CGFloat, p1: CGFloat, p2: CGFloat, c1: CGFloat, c2: CGFloat) -> CGFloat {
    // See derivation below.
    p1 - 3 * t * (p1 - c1) + 3 * t2 * (p1 - 2 * c1 + c2) - t3 * (p1 - 3 * c1 + 3 * c2 - p2)
  }

  /// Returns the length of a bezier curve broken up into segments at the given interval count.
  static func length(points: Bezier.Points, intervals: Int) -> CGFloat {
    length(p1: points.p1, p2: points.p2, c1: points.c1, c2: points.c2, intervals: intervals)
  }

  /// Returns the length of a bezier curve broken up into segments at the given interval count.
  static func length(p1: CGPoint, p2: CGPoint, c1: CGPoint, c2: CGPoint, intervals: Int) -> CGFloat {
    guard intervals > 1 else { return 0 }
    let values = intervalValues(withCount: intervals)
    let points = intervalPoints(p1: p1, p2: p2, c1: c1, c2: c2, intervals: values)
    return pairs(points).reduce(0) { (result, points) -> CGFloat in
      result + distance(points.0, points.1)
    }
  }

  /// Returns the points on a bezier curve for the given intervals.
  static func intervalPoints(p1: CGPoint, p2: CGPoint, c1: CGPoint, c2: CGPoint, intervals: [CGFloat]) -> [CGPoint] {
    intervals.map { point(t: $0, p1: p1, p2: p2, c1: c1, c2: c2) }
  }

  /// Returns interval values from 0 to 1 for the given interval count.
  static func intervalValues(withCount count: Int) -> [CGFloat] {
    guard count > 0 else { return [] }
    let interval: CGFloat = 1 / CGFloat(count)
    return (0..<count).map { CGFloat($0) * interval } + [1]
  }

  /// Returns the distance between two points.
  static func distance(_ p1: CGPoint, _ p2: CGPoint) -> CGFloat {
    sqrt(pow(p2.x - p1.x, 2) + pow(p2.y - p1.y, 2))
  }

  /// Given a set of values, returns these values as sequential pairs.
  /// For [1, 2, 3], this function returns [(1, 2), (2, 3)].
  static func pairs<T>(_ values: [T]) -> [(T, T)] {
    guard values.count > 1 else { return [] }
    var values = values
    let first = values.removeFirst()
    return values.reduce(([], first)) { (result, next) -> ([(T, T)], T) in
      return (result.0 + [(result.1, next)], next)
    }.0
  }
}

extension FloatingPoint {
  func clampedToOne() -> Self {
    max(0, min(1, self))
  }
}

/*

Derivation

Given P1, P2, C1, C2
where A1, A2, A3 are points between the lines connecting P1, P2, C1 and C2
  B1, B2 are points between the lines connecting A1, A2 and A3
  C is a point between the line connecting B1 and B2, the final bezier point

A1 = P1 + T * (C1 - P1)
A2 = C1 + T * (C2 - C1)
A3 = C2 + T * (P2 - C2)

B1 = A1 + T * (A2 - A1)
B2 = A2 + T * (A3 - A2)

C = B1 + T * (B2 - B1)

C = B1 + TB2 - TB1
C = A1 + T(A2 - A1) + T(A2 + T(A3 - A2)) - T(A1 + T(A2 - A1))
C = A1 + TA2 - TA1 + TA2 + T²(A3 - A2) - TA1 - T²(A2 - A1)
C = A1 + TA2 - TA1 + TA2 + T²A3 - T²A2 - TA1 - T²A2 + T²A1
C = A1 - 2TA1 + 2TA2 + T²A1 - 2T²A2 + T²A3

C = P1 + T(C1 - P1) - 2T(P1 + T(C1 - P1)) + 2T(C1 + T(C2 - C1)) + T²(P1 + T(C1 - P1)) - 2T²(C1 + T(C2 - C1)) + T²(C2 + T(P2 - C2))
C = P1 + TC1 - TP1 - 2T(P1 + TC1 - TP1) + 2T(C1 + TC2 - TC1) + T²(P1 + TC1 - TP1) - 2T²(C1 + TC2 - TC1) + T²(C2 + TP2 - TC2)
C = P1 + TC1 - TP1 - 2TP1 - 2T²C1 + 2T²P1 + 2TC1 + 2T²C2 - 2T²C1 + T²P1 + T³C1 - T³P1 - 2T²C1 - 2T³C2 + 2T³C1 + T²C2 + T³P2 - T³C2
C = P1 - 3TP1 + 3TC1 + 3T²P1 - 6T²C1 + 3T²C2 - T³P1 + 3T³C1 - 3T³C2 + T³P2
C = P1 - 3T(P1 - C1) + 3T²(P1 - 2C1 + C2) - T³(P1 - 3C1 + 3C2 - P2)

for p = 0
C = 3TC1 - 3T²(2C1 - C2) + T³(3C1 - 3C2 + P2)

*/
