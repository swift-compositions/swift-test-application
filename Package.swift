// swift-tools-version: 6.4

import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "swift-testing",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        // Full testing library - users import this single module
        // Contains: macros + Test namespace + core implementation
        .library(name: "Testing", targets: ["Testing"]),
        // Core implementation only (no macros) - for programmatic use
        .library(name: "Testing Core", targets: ["Testing Core"]),
        // Effects integration for testing effect handlers
        .library(name: "Testing Effects", targets: ["Testing Effects"]),
        .library(
            name: "Testing Test Support",
            targets: ["Testing Test Support"]
        ),
    ],
    dependencies: [
        // Layers 1–2: Atoms and molecules
        .package(
            url: "https://github.com/swift-molecules/swift-standard-library-extensions.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-time.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-test.git",
            branch: "main"
        ),
        // Layer 4: Runner infrastructure
        .package(url: "https://github.com/swift-compositions/swift-tests.git", branch: "main"),
        // Platform abstraction (file I/O, environment variables)
        .package(url: "https://github.com/swift-compositions/swift-kernel.git", branch: "main"),
        // Environment variable reading
        .package(url: "https://github.com/swift-compositions/swift-environment.git", branch: "main"),
        // Dynamic loader (symbol lookup)
        .package(url: "https://github.com/swift-compositions/swift-loader.git", branch: "main"),
        // Dependency injection
        .package(
            url: "https://github.com/swift-compositions/swift-dependencies.git",
            branch: "main"
        ),
        // Effects system (for optional Testing Effects target)
        .package(url: "https://github.com/swift-compositions/swift-effects.git", branch: "main"),
        // Witness system (mode context for test/live execution)
        .package(url: "https://github.com/swift-compositions/swift-witnesses.git", branch: "main"),
        // Macro implementation
        .package(url: "https://github.com/swiftlang/swift-syntax.git", "602.0.0"..<"603.0.0"),
    ],
    targets: [

        // MARK: - Umbrella

        // NOTE: [MOD-EXCEPT] Testing umbrella contains macro declarations that must
        // coexist with @_exported import of the macro implementation module.
        // This is an accepted deviation from MOD-005 (re-export-only umbrella).
        .target(
            name: "Testing",
            dependencies: [
                "Testing Core",
                "Testing Macros Implementation",
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacroExpansion", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacrosGenericTestSupport", package: "swift-syntax"),
            ],
            path: "Sources/Testing Umbrella"
        ),

        // MARK: - Core

        .target(
            name: "Testing Core",
            dependencies: [
                .product(name: "Tests", package: "swift-tests"),
                .product(name: "Tests Reporter", package: "swift-tests"),
                .product(name: "Tests Inline Snapshot", package: "swift-tests"),
                .product(name: "Test", package: "swift-test"),
                .product(
                    name: "Standard Library Extensions",
                    package: "swift-standard-library-extensions"
                ),
                .product(name: "Time", package: "swift-time"),
                .product(name: "Kernel", package: "swift-kernel"),
                .product(name: "Environment", package: "swift-environment"),
                .product(name: "Loader", package: "swift-loader"),
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "Witnesses", package: "swift-witnesses"),
            ],
            path: "Sources/Testing"
        ),

        // MARK: - Macros

        .macro(
            name: "Testing Macros Implementation",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ],
            path: "Sources/Testing Macros Implementation"
        ),

        // MARK: - Effects

        .target(
            name: "Testing Effects",
            dependencies: [
                "Testing Core",
                .product(name: "Effects", package: "swift-effects"),
                .product(name: "Effects Testing", package: "swift-effects"),
            ],
            path: "Sources/Testing Effects"
        ),

        // MARK: - Test Support

        .target(
            name: "Testing Test Support",
            dependencies: [
                "Testing Core",
                .product(
                    name: "Tests Test Support",
                    package: "swift-tests"
                ),
            ],
            path: "Tests/Support"
        ),

        // MARK: - Tests

        .testTarget(
            name: "Testing Tests",
            dependencies: [
                "Testing",
                "Testing Test Support",
            ]
        ),
        // Macro expansion tests require __TestContentRecord type from Apple's
        // swift-testing. Disabled until we bridge the test content infrastructure.
        // .testTarget(
        //     name: "Macro Expansion Tests",
        //     dependencies: [
        //         "Testing",
        //         "Testing Test Support",
        //         "Testing Macros Implementation",
        //         .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
        //         .product(name: "SwiftSyntaxMacrosGenericTestSupport", package: "swift-syntax"),
        //     ],
        //     path: "Tests/Macro Expansion Tests"
        // ),
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
