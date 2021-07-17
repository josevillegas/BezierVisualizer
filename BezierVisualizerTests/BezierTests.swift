import XCTest
@testable import BezierVisualizer

class BezierTests: XCTestCase {
  func test_timeIntervalsForDivisionCount() {
    XCTAssertEqual(Bezier.intervalValues(withCount: -1), [])
    XCTAssertEqual(Bezier.intervalValues(withCount: 0), [])
    XCTAssertEqual(Bezier.intervalValues(withCount: 1), [0, 1])
    XCTAssertEqual(Bezier.intervalValues(withCount: 2), [0, 0.5, 1])
    XCTAssertEqual(Bezier.intervalValues(withCount: 4), [0.0, 0.25, 0.5, 0.75, 1.0])
  }

  func test_pairs() {
    XCTAssertEqual(Bezier.pairs([Int]()).map { pairValues($0) }, [])
    XCTAssertEqual(Bezier.pairs([1]).map { pairValues($0) }, [])
    XCTAssertEqual(Bezier.pairs([1, 2]).map { pairValues($0) }, [[1, 2]])
    XCTAssertEqual(Bezier.pairs([1, 2, 3, 4]).map { pairValues($0) }, [[1, 2], [2, 3], [3, 4]])
  }

  func test_distance() {
    XCTAssertEqual(Bezier.distance(.zero, CGPoint(x: 3, y: 4)), 5)
  }

  private func pairValues<T>(_ pair: (T, T)) -> [T] {
    [pair.0, pair.1]
  }
}
