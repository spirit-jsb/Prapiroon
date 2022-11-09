// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "Prapiroon",
  platforms: [
    .iOS(.v11)
  ],
  products: [
    .library(name: "Prapiroon", targets: ["Prapiroon"]),
  ],
  targets: [
    .target(name: "Prapiroon", path: "Sources"),
  ],
  swiftLanguageVersions: [
    .v5
  ]
)
