// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "openai-async-image-swiftui",
    platforms: [.macOS(.v12), .iOS(.v15), .watchOS(.v8), .tvOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "openai-async-image-swiftui",
            targets: ["openai-async-image-swiftui"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/The-Igor/async-http-client.git", from: "1.4.6")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "openai-async-image-swiftui",
            dependencies: ["async-http-client"]),
        .testTarget(
            name: "openai-async-image-swiftuiTests",
            dependencies: ["openai-async-image-swiftui"]),
    ]
)
