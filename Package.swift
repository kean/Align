// swift-tools-version:5.8
import PackageDescription

let package = Package(
    name: "Align",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13),
        .macOS(.v10_15),
    ],
    products: [
        .library(name: "Align", targets: ["Align"]),
    ],
    targets: [
        .target(name: "Align",  path: "Sources"),
        .testTarget(name: "AlignTests", dependencies: ["Align"], path: "Tests")
    ]
)
