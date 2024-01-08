// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BugsplatMac",
    products: [
        .library(
            name: "BugsplatMac",
            targets: ["BugsplatMac"]),
    ],
    targets: [
        .binaryTarget(
            name: "BugsplatMac",
            url: "https://github.com/BugSplat-Git/BugSplat-macOS/releases/download/1.1.5/BugsplatMac.xcframework.zip",
            checksum: "132c951b438a82f18aa5e02e7c249c8db5dc07cd130f4448df2a572781199cb8"),
    ]
)
