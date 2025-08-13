// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "CustomActionSheet",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "CustomActionSheet",
            targets: ["CustomActionSheet"]),
    ],
    targets: [
        .target(
            name: "CustomActionSheet",
            dependencies: []),
        .testTarget(
            name: "CustomActionSheetTests",
            dependencies: ["CustomActionSheet"]),
    ]
)