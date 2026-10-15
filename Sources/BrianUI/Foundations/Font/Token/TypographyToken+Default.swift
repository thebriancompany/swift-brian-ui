import SwiftUI

extension TypographyToken {
  public static let `default` = TypographyToken(
    body: .init(
      large: .init(font: .body),
      medium: .init(font: .callout),
      small: .init(font: .footnote)
    ),
    display: .init(
      large: .init(font: .largeTitle.weight(.bold)),
      medium: .init(font: .title.weight(.bold)),
      small: .init(font: .title2.weight(.semibold))
    ),
    label: .init(
      large: .init(font: .headline.weight(.semibold)),
      medium: .init(font: .subheadline.weight(.medium)),
      small: .init(font: .caption.weight(.medium))
    ),
    title: .init(
      large: .init(font: .title.weight(.semibold)),
      medium: .init(font: .title2.weight(.semibold)),
      small: .init(font: .title3.weight(.semibold))
    )
  )
}
