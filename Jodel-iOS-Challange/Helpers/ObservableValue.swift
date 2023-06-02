final class ObservableValue<T> {
  typealias ListenerType = (T) -> Void
  private var listener: ListenerType?
  var value: T {
  didSet {
    listener?(value)
    }
  }

  init(_ value: T) {
    self.value = value
  }

  func bind(listener: ListenerType?) {
    self.listener = listener
    listener?(value)
  }

  func unbind() {
    listener = nil
  }

  deinit {
    unbind()
  }
}
