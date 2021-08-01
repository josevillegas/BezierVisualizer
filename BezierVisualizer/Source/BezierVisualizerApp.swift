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
  @State private var bezierValues: Bezier.Values = .zero
  @State private var isTimeViewVisible = false
  @State private var initialPathViewSize: CGSize = .zero

  var body: some View {
    VStack(spacing: 0) {
      BezierView(bezierValues: $bezierValues, isTimeViewVisible: $isTimeViewVisible, initialPathViewSize: $initialPathViewSize)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      Divider()
      BezierControlsView(bezierValues: $bezierValues, isToggleOn: $isTimeViewVisible)
    }
      .background(Color.yellow.ignoresSafeArea(edges: .top))
      .onChange(of: initialPathViewSize) { size in bezierValues.points = Bezier.Points.square(in: size) }
  }
}

struct BezierControlsView: View {
  @Binding var bezierValues: Bezier.Values
  @Binding var isToggleOn: Bool

  var body: some View {
    VStack(spacing: 16) {
      HStack(spacing: 24) {
        Slider(value: $bezierValues.time) {}
          .disabled(!isToggleOn)
          .id(isToggleOn)
        Toggle(isOn: $isToggleOn, label: { Text("") })
          .labelsHidden()
      }
      HStack {
        BezierInfoView(points: $bezierValues.points)
        Spacer()
      }
    }
      .padding(EdgeInsets(top: 12, leading: 24, bottom: 0, trailing: 24))
      .background(Color(UIColor.systemBackground))
  }
}
