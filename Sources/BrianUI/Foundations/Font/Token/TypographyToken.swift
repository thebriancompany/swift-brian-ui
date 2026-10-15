import Foundation

public struct TypographyToken: Hashable, Sendable {
  public var body: Body
  public var display: Display
  public var label: Label
  public var title: Title

  public init(
    body: Body,
    display: Display,
    label: Label,
    title: Title
  ) {
    self.body = body
    self.display = display
    self.label = label
    self.title = title
  }
}
