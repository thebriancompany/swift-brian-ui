import SwiftUI

extension ColorPalette {
  public static let `default` = ColorPalette(
    black: .adaptive(light: 0x000000, dark: 0x000000),
    blackAlpha: .init(
      `100`: .black.opacity(0.04),
      `200`: .black.opacity(0.08),
      `300`: .black.opacity(0.12),
      `400`: .black.opacity(0.18),
      `500`: .black.opacity(0.26),
      `600`: .black.opacity(0.38),
      `700`: .black.opacity(0.52),
      `800`: .black.opacity(0.66),
      `900`: .black.opacity(0.82),
      `1000`: .black.opacity(1)
    ),
    blue: .init(
      `100`: .adaptive(light: 0xEFF6FF, dark: 0x16243B),
      `200`: .adaptive(light: 0xE9F1FF, dark: 0x1B3052),
      `300`: .adaptive(light: 0xBDD7FF, dark: 0x234273),
      `400`: .adaptive(light: 0x8FBAFF, dark: 0x2C5798),
      `500`: .adaptive(light: 0x609AFF, dark: 0x306AC2),
      `600`: .adaptive(light: 0x3D7FF2, dark: 0x2563EB),
      `700`: .adaptive(light: 0x2563EB, dark: 0x83B4FF),
      `800`: .adaptive(light: 0x1D4ED8, dark: 0xA7CAFF),
      `900`: .adaptive(light: 0x1E40AF, dark: 0xC9DFFF),
      `1000`: .adaptive(light: 0x172E70, dark: 0xE4EFFF)
    ),
    gray: .init(
      `0`: .adaptive(light: 0xFFFFFF, dark: 0x111214),
      `100`: .adaptive(light: 0xF7F8FA, dark: 0x18191C),
      `200`: .adaptive(light: 0xF0F1F3, dark: 0x232529),
      `300`: .adaptive(light: 0xE7E9ED, dark: 0x303238),
      `400`: .adaptive(light: 0xD8DCE2, dark: 0x43474F),
      `500`: .adaptive(light: 0xB9C1CD, dark: 0x566276),
      `600`: .adaptive(light: 0x8993A3, dark: 0x748196),
      `700`: .adaptive(light: 0x656E7B, dark: 0x9AA8BC),
      `800`: .adaptive(light: 0x434B57, dark: 0xBAC6D6),
      `900`: .adaptive(light: 0x303B4B, dark: 0xD8E1ED),
      `1000`: .adaptive(light: 0x171C24, dark: 0xF0F4FA)
    ),
    green: .init(
      `100`: .adaptive(light: 0xEDF9F2, dark: 0x152A20),
      `200`: .adaptive(light: 0xD7F1E1, dark: 0x193B2B),
      `300`: .adaptive(light: 0xB4E3C7, dark: 0x20513A),
      `400`: .adaptive(light: 0x80CDA3, dark: 0x256747),
      `500`: .adaptive(light: 0x4CB47E, dark: 0x167346),
      `600`: .adaptive(light: 0x26945E, dark: 0x21844F),
      `700`: .adaptive(light: 0x167346, dark: 0x6ACF97),
      `800`: .adaptive(light: 0x105C38, dark: 0x94E1B3),
      `900`: .adaptive(light: 0x10492E, dark: 0xBDEFD1),
      `1000`: .adaptive(light: 0x103A27, dark: 0xE1F8E9)
    ),
    orange: .init(
      `100`: .adaptive(light: 0xFFF4EC, dark: 0x302017),
      `200`: .adaptive(light: 0xFFE6D4, dark: 0x452A1A),
      `300`: .adaptive(light: 0xFFCEAA, dark: 0x603820),
      `400`: .adaptive(light: 0xFFAE74, dark: 0x804725),
      `500`: .adaptive(light: 0xF78B44, dark: 0xA65527),
      `600`: .adaptive(light: 0xE76C24, dark: 0xC96A30),
      `700`: .adaptive(light: 0xBD4D14, dark: 0xF8AC76),
      `800`: .adaptive(light: 0x993C10, dark: 0xFFC69E),
      `900`: .adaptive(light: 0x783211, dark: 0xFFDDC4),
      `1000`: .adaptive(light: 0x59270F, dark: 0xFFEDE0)
    ),
    purple: .init(
      `100`: .adaptive(light: 0xF6F2FF, dark: 0x261D36),
      `200`: .adaptive(light: 0xECE3FF, dark: 0x35254C),
      `300`: .adaptive(light: 0xD9C7FF, dark: 0x493165),
      `400`: .adaptive(light: 0xBFA2FA, dark: 0x5D3C81),
      `500`: .adaptive(light: 0xA17BED, dark: 0x71499D),
      `600`: .adaptive(light: 0x8659D5, dark: 0x8053B5),
      `700`: .adaptive(light: 0x6E3DBB, dark: 0xB597ED),
      `800`: .adaptive(light: 0x582C9B, dark: 0xCEB9F8),
      `900`: .adaptive(light: 0x452478, dark: 0xE3D5FF),
      `1000`: .adaptive(light: 0x341D59, dark: 0xF1E9FF)
    ),
    red: .init(
      `100`: .adaptive(light: 0xFFF1F2, dark: 0x321C23),
      `200`: .adaptive(light: 0xFFE5E8, dark: 0x48232D),
      `300`: .adaptive(light: 0xFFC2CA, dark: 0x632C3A),
      `400`: .adaptive(light: 0xFF98A6, dark: 0x813447),
      `500`: .adaptive(light: 0xF66D80, dark: 0xA43A52),
      `600`: .adaptive(light: 0xE54860, dark: 0xC52F49),
      `700`: .adaptive(light: 0xC52F49, dark: 0xFF91A4),
      `800`: .adaptive(light: 0xA3243B, dark: 0xFFB5C1),
      `900`: .adaptive(light: 0x811F32, dark: 0xFFD5DC),
      `1000`: .adaptive(light: 0x611B29, dark: 0xFFE9ED)
    ),
    white: .adaptive(light: 0xFFFFFF, dark: 0xFFFFFF),
    whiteAlpha: .init(
      `50`: .white.opacity(0.04),
      `100`: .white.opacity(0.08),
      `200`: .white.opacity(0.12),
      `300`: .white.opacity(0.18),
      `400`: .white.opacity(0.26),
      `500`: .white.opacity(0.36),
      `600`: .white.opacity(0.48),
      `700`: .white.opacity(0.6),
      `800`: .white.opacity(0.74),
      `900`: .white.opacity(0.88),
      `1000`: .white.opacity(1)
    ),
    yellow: .init(
      `100`: .adaptive(light: 0xFFFAE8, dark: 0x2D2616),
      `200`: .adaptive(light: 0xFFF1BD, dark: 0x41351B),
      `300`: .adaptive(light: 0xFFE38A, dark: 0x584721),
      `400`: .adaptive(light: 0xFFD45C, dark: 0x725C28),
      `500`: .adaptive(light: 0xF5BD35, dark: 0x8E732E),
      `600`: .adaptive(light: 0xDBA021, dark: 0xAC8C37),
      `700`: .adaptive(light: 0x936517, dark: 0xDEC16A),
      `800`: .adaptive(light: 0x775014, dark: 0xF0D588),
      `900`: .adaptive(light: 0x604114, dark: 0xF7E3AD),
      `1000`: .adaptive(light: 0x493212, dark: 0xFDF0CF)
    )
  )
}
