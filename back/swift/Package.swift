// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "swift-ttt",
    platforms: [
        .macOS(.v12)
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0")
    ],
    targets: [
        .target(
            name: "App",
            dependencies: [
                .product(name: "Vapor", package: "vapor")
            ],
            path: "app"
        ),
        .testTarget(
            name: "AppTests",
            dependencies: [
                .target(name: "App")
            ],
            path: "app/test"
        )
    ]
)
