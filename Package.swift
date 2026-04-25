// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "Align",
    platforms: [
        .iOS(.v15),
        .tvOS(.v15),
        .macOS(.v13),
        .visionOS(.v1)
    ],
    products: [
        .library(name: "Align", targets: ["Align"]),
    ],
    targets: [
        .target(name: "Align",  path: "Sources"),
        .testTarget(name: "AlignTests", dependencies: ["Align"], path: "Tests")
    ]
)
