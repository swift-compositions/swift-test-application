// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-test-application",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(name: "Test Application", targets: ["Test Application"]),
        .executable(name: "Test CLI", targets: ["Test CLI"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-primitives/swift-test-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-foundations/swift-process.git",
            branch: "main"
        ),
    ],
    targets: [
        .target(
            name: "Test Application",
            dependencies: [
                .product(name: "Test Primitives Core", package: "swift-test-primitives"),
                .product(name: "Process", package: "swift-process"),
            ]
        ),
        .executableTarget(
            name: "Test CLI",
            dependencies: [
                "Test Application",
                .product(name: "Process", package: "swift-process"),
            ]
        ),
        .testTarget(
            name: "Test Application Tests",
            dependencies: ["Test Application"]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("LifetimeDependence"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("LifetimeDependence"),
    ]

    let package: [SwiftSetting] = []
    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
