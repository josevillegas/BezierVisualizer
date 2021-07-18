import SwiftUI

@main
struct BezierVisualizerApp: App {
  var body: some Scene {
    WindowGroup {
      BezierVisualizerView()
    }
  }
}

struct BezierVisualizerView: View {
  @State private var points: Bezier.Points = .zero
  @State private var time: Float = 0
  @State private var isTimeViewVisible = false
  @State private var pathViewSize: CGSize = .zero

  var body: some View {
    VStack(spacing: 0) {
      BezierView(points: $points, time: $time, isTimeViewVisible: $isTimeViewVisible, pathViewSize: $pathViewSize)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      Divider()
      BezierControlsView(points: $points, time: $time, isToggleOn: $isTimeViewVisible)
        .padding(EdgeInsets(top: 12, leading: 24, bottom: 0, trailing: 24))
    }
      .onChange(of: pathViewSize) { size in points = Bezier.Points.values(in: size) }
  }
}
