// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "rps",
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.86.0"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "5.0.0"),
    ],
    targets: [
        .target(
            name: "Core",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "Yams", package: "Yams"),
            ],
            path: "Sources/Core"
        ),
        .target(
            name: "MonsterCore",
            dependencies: [
                "Core",
                .product(name: "Vapor", package: "vapor"),
                .product(name: "Yams", package: "Yams"),
            ],
            path: "Sources/MonsterCore"
        ),
        .target(
            name: "PlayerCore",
            dependencies: [
                "Core"
            ],
            path: "Sources/PlayerCore"
        ),
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "PlayerBook",
            dependencies: [
                "Core",
                "PlayerCore",
            ],
            path: "Sources/PlayerBook"
        ),
        .executableTarget(
            name: "MonsterBook",
            dependencies: [
                "Core",
                "MonsterCore",
            ],
            path: "Sources/MonsterBook"
        ),
        .executableTarget(
            name: "CoreBook",
            dependencies: [
                "Core"
            ],
            path: "Sources/CoreBook"
        ),
        .testTarget(
            name: "CoreTests",
            dependencies: ["Core"],
            path: "Tests/CoreTests"
        ),
        // .testTarget(
        //     name: "PlayerCoreTests",
        //     dependencies: ["PlayerCore"],
        //     path: "Tests/PlayerCoreTests"
        // ),
        // .testTarget(
        //     name: "MonsterCoreTests",
        //     dependencies: ["MonsterCore"],
        //     path: "Tests/MonsterCoreTests"
        // ),
    ]
)
