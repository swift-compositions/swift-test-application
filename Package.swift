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
        .package(url: "https://github.com/swift-primitives/swift-test.git", branch: "testing-stack/neutral-test-boundary"),
        .package(url: "https://github.com/swift-primitives/swift-application-primitives.git", branch: "main"),
        .package(
            url: "https://github.com/swift-foundations/swift-process.git",
            branch: "main"
        ),
        .package(url: "https://github.com/swift-foundations/swift-environment.git", branch: "main"),
        .package(url: "https://github.com/swift-foundations/swift-console.git", branch: "main"),
        .package(url: "https://github.com/swift-foundations/swift-json.git", branch: "testing-stack/json-no-syntax"),
        .package(url: "https://github.com/swift-foundations/swift-file-system.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-benchmark.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-byte-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-either-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-cardinal-primitives.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "Test Application",
            dependencies: [
                .product(name: "Test", package: "swift-test"),
                .product(name: "Application Primitives", package: "swift-application-primitives"),
                .product(name: "Process", package: "swift-process"),
                .product(name: "Environment", package: "swift-environment"),
                .product(name: "Environment Core", package: "swift-environment"),
                .product(name: "JSON", package: "swift-json"),
                .product(name: "File System Core", package: "swift-file-system"),
                .product(name: "Benchmark", package: "swift-benchmark"),
                .product(name: "Byte Primitive", package: "swift-byte-primitives"),
                .product(name: "Either Primitives", package: "swift-either-primitives"),
                .product(name: "Cardinal Primitive", package: "swift-cardinal-primitives"),
            ]
        ),
        .executableTarget(
            name: "Test CLI",
            dependencies: [
                .target(name: "Test Application"),
                .product(name: "Test", package: "swift-test"),
                .product(name: "Console", package: "swift-console"),
                .product(name: "Environment", package: "swift-environment"),
                .product(name: "Environment Core", package: "swift-environment"),
                .product(name: "Process", package: "swift-process"),
            ]
        ),
        .testTarget(
            name: "Test Application Tests",
            dependencies: [
                .target(name: "Test Application"),
                .product(name: "Test", package: "swift-test"),
                .product(name: "Application Primitives", package: "swift-application-primitives"),
                .product(name: "JSON", package: "swift-json"),
                .product(name: "File System Core", package: "swift-file-system"),
                .product(name: "Benchmark", package: "swift-benchmark"),
                .product(name: "Byte Primitive", package: "swift-byte-primitives"),
                .product(name: "Either Primitives", package: "swift-either-primitives"),
                .product(name: "Cardinal Primitive", package: "swift-cardinal-primitives"),
            ]
        ),
        .testTarget(
            name: "Test CLI Tests",
            dependencies: [
                .target(name: "Test CLI"),
                .target(name: "Test Application"),
                .product(name: "Test", package: "swift-test"),
                .product(name: "Environment", package: "swift-environment"),
            ]
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
