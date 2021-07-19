import SwiftUI

extension View {
  func draggable(position: Binding<CGPoint>) -> some View {
    modifier(Draggable(position: position))
  }
}

struct Draggable: ViewModifier {
  @Binding var dragPosition: CGPoint

  @State private var isDragging = false
  @State private var lastPosition: CGPoint

  init(position: Binding<CGPoint>) {
    _dragPosition = position
    lastPosition = position.wrappedValue
  }

  func body(content: Self.Content) -> some View {
    content
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
