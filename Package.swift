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
  targets: [
    .target(
      name: "BrianUI",
    ),
  ]
)
