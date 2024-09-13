// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "Align",
    platforms: [
        .iOS(.v14),
        .tvOS(.v14),
        .macOS(.v10_16),
    ],
    products: [
        .library(name: "Align", targets: ["Align"]),
    ],
    targets: [
        .target(name: "Align",  path: "Sources"),
        .testTarget(name: "AlignTests", dependencies: ["Align"], path: "Tests")
    ]
)
