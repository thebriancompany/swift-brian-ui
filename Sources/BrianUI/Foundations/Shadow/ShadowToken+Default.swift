import SwiftUI

extension ShadowToken {
  public static let `default` = Self(
    elevated: .init(
      primary: .init(
        color: ColorPalette.default.blackAlpha[.`300`],
        radius: 12,
        y: 4
      )
    ),
    floating: .init(
      primary: .init(
        color: ColorPalette.default.blackAlpha[.`300`],
        radius: 12,
        y: 4
      ),
      secondary: .init(
        color: ColorPalette.default.blackAlpha[.`200`],
        radius: 3,
        y: 2
      )
    )
  )
}
