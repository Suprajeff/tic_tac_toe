// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "swift-ttt",
    platforms: [
        .macOS(.v12)
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
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
