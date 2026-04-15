// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "ResearchKit",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "ResearchKit",
            targets: ["ResearchKit"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "ResearchKit",
            path: "Binary/ResearchKit.xcframework"
        )
    ]
)
