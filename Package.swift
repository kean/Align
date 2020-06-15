// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "Align",
    platforms: [
        .iOS(.v11),
        .tvOS(.v11)
    ],
    products: [
        .library(name: "Align", targets: ["Align"]),
    ],
    targets: [
        .target(name: "Align", path: "Sources")
    ]
)
