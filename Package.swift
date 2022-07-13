// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "Align",
    platforms: [
        .iOS(.v12),
        .tvOS(.v12),
        .macOS(.v10_14),
    ],
    products: [
        .library(name: "Align", type: .dynamic, targets: ["Align"]),
    ],
    targets: [
        .target(name: "Align",  path: "Sources"),
        .testTarget(name: "AlignTests", dependencies: ["Align"], path: "Tests")
    ]
)
