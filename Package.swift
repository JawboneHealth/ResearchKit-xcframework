// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "ResearchKit",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "ResearchKit",
            targets: ["ResearchKit"]
        ),
        .library(
            name: "ResearchKitUI",
            targets: ["ResearchKitUI"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "ResearchKit",
            path: "Binary/ResearchKit.xcframework"
        ),
        .binaryTarget(
            name: "ResearchKitUI",
            path: "Binary/ResearchKitUI.xcframework"
        )
    ]
)
