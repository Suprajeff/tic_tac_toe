// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "swift-ttt",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(name: "swift-ttt", targets: ["Main"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/redis.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/websocket-kit.git", from: "2.0.0")
    ],
    targets: [
        .executableTarget(
            name: "Main",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "Redis", package: "redis"),
                .product(name: "WebSocketKit", package: "websocket-kit")
            ],
            path: "app"
        ),
        .testTarget(
            name: "AppTests",
            dependencies: [
                .target(name: "Main")
            ],
            path: "app/test"
        )
    ]
)
