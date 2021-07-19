extension FloatingPoint {
  func clampedToOne() -> Self {
    max(0, min(1, self))
  }
}
