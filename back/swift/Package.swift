// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "swift-ttt",
    platforms: [
        .macOS(.v12)
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/redis.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/websocket.git", from: "4.0.0")
    ],
    targets: [
        .target(
            name: "App",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "Redis", package: "redis"),
                .product(name: "WebSocket", package: "websocket")
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
