// swift-tools-version: 6.4

import PackageDescription

let package = Package(
  name: "swift-brian-ui",
  platforms: [
    .iOS(.v18),
    .macOS(.v15)
  ],
  products: [
    .library(
      name: "BrianUI",
      targets: ["BrianUI"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/thebriancompany/swift-brian-symbols", from: "0.10.0"),
  ],
  targets: [
    .target(
      name: "BrianUI",
      dependencies: [
        .product(name: "BrianSymbols", package: "swift-brian-symbols")
      ]
    ),
  ]
)
