// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WWSegmentControlView",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "WWSegmentControlView", targets: ["WWSegmentControlView"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "WWSegmentControlView", dependencies: [], resources: [.process("Xib")]),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
