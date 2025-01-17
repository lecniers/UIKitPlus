import UIKit

extension DeclarativeProtocol {
    @discardableResult
    public func onLongPressGesture(taps: Int = 0, touches: Int = 1, on state: UIGestureRecognizer.State, _ action: @escaping () -> Void) -> Self {
        onLongPressGesture(taps: taps, touches: touches, on: state) { v, r in
            action()
        }
    }
    
    @discardableResult
    public func onLongPressGesture(taps: Int = 0, touches: Int = 1, on state: UIGestureRecognizer.State, _ action: @escaping (Self) -> Void) -> Self {
        onLongPressGesture(taps: taps, touches: touches, on: state) { v, r in
            action(self)
        }
    }
    
    @discardableResult
    public func onLongPressGesture(taps: Int = 0, touches: Int = 1, on state: UIGestureRecognizer.State, _ action: @escaping (Self, LongPressGestureRecognizer) -> Void) -> Self {
        onLongPressGesture(taps: taps, touches: touches) { v, s, r in
            if s == state {
                action(v, r)
            }
        }
    }
    
    @discardableResult
    public func onLongPressGesture(taps: Int = 0, touches: Int = 1, _ action: @escaping (Self) -> Void) -> Self {
        onLongPressGesture(taps: taps, touches: touches) { v, s, r in
            action(v)
        }
    }
    
    @discardableResult
    public func onLongPressGesture(taps: Int = 0, touches: Int = 1, _ action: @escaping (Self, UIGestureRecognizer.State) -> Void) -> Self {
        onLongPressGesture(taps: taps, touches: touches) { v, s, r in
            action(v, s)
        }
    }
    
    @discardableResult
    public func onLongPressGesture(taps: Int = 0, touches: Int = 1, _ action: @escaping (Self, UIGestureRecognizer.State, LongPressGestureRecognizer) -> Void) -> Self {
        let recognizer = LongPressGestureRecognizer(taps: taps, touches: touches)
        declarativeView.addGestureRecognizer(recognizer.trackState {
            action(self, $0, recognizer)
        })
        return self
    }
    
    @discardableResult
    public func onLongPressGesture(taps: Int = 0, touches: Int = 1, _ state: State<UIGestureRecognizer.State>) -> Self {
        onLongPressGesture(taps: taps, touches: touches) { v, s, r in
            state.wrappedValue = s
        }
    }

    @discardableResult
    public func onLongPressGesture<V>(taps: Int = 0, touches: Int = 1, _ expressable: ExpressableState<V, UIGestureRecognizer.State>) -> Self {
        onLongPressGesture(taps: taps, touches: touches, expressable.unwrap())
    }
}
