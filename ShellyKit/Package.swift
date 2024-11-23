// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ShellyKit",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "ShellyKit",
            targets: ["ShellyKit"]
        )
    ],
    targets: [
        .target(
            name: "ShellyKit"
        ),
        .testTarget(
            name: "ShellyKitTests",
            dependencies: ["ShellyKit"]
        )
    ]
)
