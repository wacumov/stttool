// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "STTTool",
    platforms: [.macOS(.v12)],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.1.0"),
        .package(url: "https://github.com/AudioKit/AudioKit.git", from: "5.6.0"),
        .package(url: "https://github.com/exPHAT/SwiftWhisper.git", from: "1.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "STTTool",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "AudioKit", package: "AudioKit"),
                .product(name: "SwiftWhisper", package: "SwiftWhisper"),
            ]
        ),
    ]
)
