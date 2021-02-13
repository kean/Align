// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "Align",
    platforms: [
        .iOS(.v11),
        .tvOS(.v11),
        .macOS(.v10_13),
    ],
    products: [
        .library(name: "Align", type: .dynamic, targets: ["Align"]),
    ],
    targets: [
        .target(name: "Align",  path: "Sources")
    ]
)
