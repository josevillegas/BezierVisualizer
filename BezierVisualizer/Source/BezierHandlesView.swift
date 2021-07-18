import SwiftUI

struct BezierHandlesView: View {
  @Binding var points: Bezier.Points

  var body: some View {
    ZStack {
      HandleView(position: $points.p1)
      HandleView(position: $points.p2)
      HandleView(position: $points.c1)
      HandleView(position: $points.c2)
    }
  }
}

struct HandleView: View {
  @Binding var dragPosition: CGPoint

  @State private var isDragging = false
  @State private var lastPosition: CGPoint

  init(position: Binding<CGPoint>) {
    _dragPosition = position
    lastPosition = position.wrappedValue
  }

  var body: some View {
    ZStack {
      Circle()
        .fill(Color.white)
      Circle()
        .stroke(Color.red, lineWidth: 2)
    }
      .frame(width: 10, height: 10)
      .padding(17)
      .position(dragPosition)
      .gesture(drag)
      .onChange(of: dragPosition) { value in
        guard !isDragging else { return }
        // Update the last position if `dragPosition`
        // was updated from outside this view.
        lastPosition = dragPosition
      }
  }

  var drag: some Gesture {
    DragGesture()
      .onChanged { gesture in
        isDragging = true
        dragPosition = CGPoint(
          x: lastPosition.x + gesture.translation.width,
          y: lastPosition.y + gesture.translation.height
        )
      }
      .onEnded { gesture in
        lastPosition = dragPosition
        isDragging = false
      }
  }
}
