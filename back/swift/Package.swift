// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "swift-ttt",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(name: "swift-ttt", targets: ["TicTacToe"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.42.0"),
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/redis.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/websocket-kit.git", from: "2.0.0")
    ],
    targets: [
        .executableTarget(
            name: "TicTacToe",
            dependencies: [
                .product(name: "NIO", package: "swift-nio"),
                .product(name: "Vapor", package: "vapor"),
                .product(name: "Redis", package: "redis"),
                .product(name: "WebSocketKit", package: "websocket-kit")
            ]
        ),
        .testTarget(
            name: "TicTacToeTests",
            dependencies: [
                .target(name: "TicTacToe")
            ]
        )
    ]
)
