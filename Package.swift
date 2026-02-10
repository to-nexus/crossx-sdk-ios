// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CROSSxSDK",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "CROSSxSDK",
            targets: ["CROSSxSDK"]
        ),
        .library(
            name: "CrossWebAuthKit",
            targets: ["CrossWebAuthKit"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "CROSSxSDK",
            path: "CROSSxSDK.xcframework"
        ),
        .binaryTarget(
            name: "CrossWebAuthKit",
            path: "CrossWebAuthKit.xcframework"
        )
    ]
)
