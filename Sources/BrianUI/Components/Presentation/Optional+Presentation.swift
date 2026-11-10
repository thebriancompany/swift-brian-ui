extension Optional where Wrapped: Identifiable {
  /// Scopes dismissal to the item that supplied the presented content.
  subscript(brianIsPresented id: Wrapped.ID?) -> Bool {
    get { self != nil && self?.id == id }
    set {
      guard !newValue, self?.id == id else { return }
      self = nil
    }
  }
}
