// swift-tools-version: 5.6

// WARNING:
// This file is automatically generated.
// Do not edit it by hand because the contents will be replaced.

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "CanineCalc",
    platforms: [
        .iOS("15.2")
    ],
    products: [
        .iOSApplication(
            name: "CanineCalc",
            targets: ["AppModule"],
            bundleIdentifier: "jevonlevin.CanineCalc",
            teamIdentifier: "9F7W272RND",
            displayVersion: "1.0",
            bundleVersion: "1",
            appIcon: .placeholder(icon: .paper),
            accentColor: .presetColor(.cyan),
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft,
                .portraitUpsideDown(.when(deviceFamilies: [.pad]))
            ]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/ValentinWalter/LiquidShape", "1.0.0"..<"2.0.0"),
        .package(url: "https://github.com/airbnb/lottie-ios", .branch("master")),
        .package(url: "https://github.com/jasudev/LottieUI.git", .branch("main")),
        .package(url: "https://github.com/lucasbrown/swiftui-visual-effects", "1.0.3"..<"2.0.0")
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            dependencies: [
                .product(name: "LiquidShape", package: "LiquidShape"),
                .product(name: "Lottie", package: "lottie-ios"),
                .product(name: "LottieUI", package: "lottieui"),
                .product(name: "SwiftUIVisualEffects", package: "swiftui-visual-effects")
            ],
            path: ".",
            resources: [
                .process("Resources")
            ]
        )
    ]
)