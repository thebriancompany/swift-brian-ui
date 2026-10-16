import SwiftUI

struct BrianBottomSheetHostedContent<Content: View>: View {
  let content: Content
  let environment: EnvironmentValues

  var body: some View {
    content
      .environment(\.self, environment)
  }
}
