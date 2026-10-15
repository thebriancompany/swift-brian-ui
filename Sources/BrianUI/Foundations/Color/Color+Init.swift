import SwiftUI

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

extension Color {
  public static func adaptive(
    light: UInt,
    dark: UInt,
    lightOpacity: Double = 1,
    darkOpacity: Double? = nil
  ) -> Color {
    let resolvedDarkOpacity = darkOpacity ?? lightOpacity

#if canImport(UIKit)
    return Color(
      uiColor: UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
        ? .color(hex: dark, opacity: resolvedDarkOpacity)
        : .color(hex: light, opacity: lightOpacity)
      })
#elseif canImport(AppKit)
    return Color(
      nsColor: NSColor(name: nil) { appearance in
        appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
        ? .color(hex: dark, opacity: resolvedDarkOpacity)
        : .color(hex: light, opacity: lightOpacity)
      })
#else
    return Color(
      red: Double((light >> 16) & 0xFF) / 255,
      green: Double((light >> 8) & 0xFF) / 255,
      blue: Double(light & 0xFF) / 255,
      opacity: lightOpacity
    )
#endif
  }

  public static func adaptive(light: Color, dark: Color) -> Color {
#if canImport(UIKit)
    return Color(
      uiColor: UIColor { traitCollection in
        let color = traitCollection.userInterfaceStyle == .dark ? dark : light
        return UIColor(color).resolvedColor(with: traitCollection)
      })
#elseif canImport(AppKit)
    return Color(
      nsColor: NSColor(name: nil) { appearance in
        let color = NSColor(
          appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua ? dark : light
        )
        var resolved = color
        appearance.performAsCurrentDrawingAppearance {
          resolved = color.usingColorSpace(.sRGB) ?? color
        }
        return resolved
      })
#else
    return light
#endif
  }
}

#if canImport(UIKit)
extension UIColor {
  static func color(hex: UInt, opacity: Double) -> UIColor {
    let red = CGFloat((hex >> 16) & 0xFF) / 255
    let green = CGFloat((hex >> 8) & 0xFF) / 255
    let blue = CGFloat(hex & 0xFF) / 255

    return UIColor(
      red: red,
      green: green,
      blue: blue,
      alpha: opacity
    )
  }
}
#elseif canImport(AppKit)
extension NSColor {
  static func color(hex: UInt, opacity: Double) -> NSColor {
    let red = CGFloat((hex >> 16) & 0xFF) / 255
    let green = CGFloat((hex >> 8) & 0xFF) / 255
    let blue = CGFloat(hex & 0xFF) / 255

    return NSColor(
      srgbRed: red,
      green: green,
      blue: blue,
      alpha: opacity
    )
  }
}
#endif
