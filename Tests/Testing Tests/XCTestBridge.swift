// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-testing open source project
//
// Copyright (c) 2024-2025 Coen ten Thije Boonkkamp and the swift-testing project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

import Test_Primitives
import Testing
import Testing_Test_Support
// This file's whole purpose is the XCTest bridge described below: it
// deliberately imports XCTest and subclasses XCTestCase so SwiftPM's
// `xctest`-based macOS test runner can discover our @Test-based suites.
// swiftlint:disable no_xctest_import no_xctestcase_subclass
import XCTest

// MARK: - XCTest Bridge
//
// SwiftPM's test runner on macOS uses the `xctest` utility which cannot invoke
// our Testing framework's entry point. This bridge makes @Test-based tests
// discoverable through XCTest infrastructure.
//
// Each suite is instantiated and its methods called directly. Test assertions
// use our #expect / #require macros internally; failures are mapped to XCTest
// via XCTAssert at the suite level.
//
// WORKAROUND: __swift5_tests section records use a different layout than
// Apple's swift-testing (absolute vs relative pointers). Section-based
// discovery crashes when the Swift runtime parses our records during image
// loading. This bridge bypasses section discovery entirely.
// WHY: Our record accessor boxes institute-specific registration payloads;
// the runtime's built-in section parser assumes Apple's upstream layout and
// cannot be reused as-is for XCTest-driven runs.
// WHEN TO REMOVE: When our record format aligns with Apple's, or we use
// a distinct section name with SymbolLinkageMarkers support.
// TRACKING: Research/suite-record-discovery-gap.md.

// MARK: - Helpers Tests

final class HelpersTests: XCTestCase {
    func testExpectWithTrueReturnsPassingExpectation() {
        Testing.`Helpers Test`.Unit().expectWithTrueReturnsPassingExpectation()
    }

    func testExpectWithFalseReturnsFailingExpectation() {
        Testing.`Helpers Test`.Unit().expectWithFalseReturnsFailingExpectation()
    }

    func testRequireWithTrueDoesNotThrow() throws {
        try Testing.`Helpers Test`.Unit().requireWithTrueDoesNotThrow()
    }

    func testRequireWithNonNilOptionalReturnsUnwrappedValue() throws {
        try Testing.`Helpers Test`.Unit().requireWithNonNilOptionalReturnsUnwrappedValue()
    }

    func testRequireWithFalseThrows() {
        Testing.`Helpers Test`.`Edge Case`().requireWithFalseThrows()
    }

    func testRequireWithNilOptionalThrows() {
        Testing.`Helpers Test`.`Edge Case`().requireWithNilOptionalThrows()
    }
}

// MARK: - MacroSupport Tests

final class MacroSupportTests: XCTestCase {
    func testTestIDResolvesToTestID() {
        Testing.`Macro Support Test`.Unit().testIDResolvesToTestID()
    }

    func testTestSourceLocationResolvesToTestSourceLocation() {
        Testing.`Macro Support Test`.Unit().testSourceLocationResolvesToTestSourceLocation()
    }

    func testTestTraitResolvesToTestTrait() {
        Testing.`Macro Support Test`.Unit().testTraitResolvesToTestTrait()
    }

    func testTestBodyResolvesCorrectly() {
        Testing.`Macro Support Test`.Unit().testBodyResolvesCorrectly()
    }
}

// MARK: - Configuration Tests

final class ConfigurationTests: XCTestCase {
    func testInitCreatesDefaultConfigurationWithNilFilter() {
        Testing.Configuration.Test.Unit().initCreatesDefaultConfigurationWithNilFilter()
    }

    func testInitCreatesDefaultConfigurationWithNilTags() {
        Testing.Configuration.Test.Unit().initCreatesDefaultConfigurationWithNilTags()
    }

    func testInitCreatesDefaultConfigurationWithAutomaticConcurrency() {
        Testing.Configuration.Test.Unit().initCreatesDefaultConfigurationWithAutomaticConcurrency()
    }

    func testInitCreatesDefaultConfigurationWithTeeOutputFormat() {
        Testing.Configuration.Test.Unit().initCreatesDefaultConfigurationWithTeeOutputFormat()
    }

    func testInitCreatesDefaultConfigurationWithNilOutputPath() {
        Testing.Configuration.Test.Unit().initCreatesDefaultConfigurationWithNilOutputPath()
    }

    func testStubFactoryCreatesConfigurationWithProvidedValues() {
        Testing.Configuration.Test.Unit().stubFactoryCreatesConfigurationWithProvidedValues()
    }

    func testCurrentWithNoEnvVarsReturnsDefaults() {
        Testing.Configuration.Test.`Edge Case`().currentWithNoEnvVarsReturnsDefaults()
    }
}

// MARK: - Configuration.Output.Format Tests

final class ConfigurationOutputFormatTests: XCTestCase {
    func testConsoleAndJsonCasesAreDistinct() {
        Testing.Configuration.Output.Format.Test.Unit().consoleAndJsonCasesAreDistinct()
    }
}

// MARK: - Discovery Tests

final class DiscoveryTests: XCTestCase {
    func testSectionsReturnsARegistry() {
        Testing.Discovery.Test.Integration().sectionsReturnsARegistry()
    }

    func testAllReturnsARegistry() {
        Testing.Discovery.Test.Integration().allReturnsARegistry()
    }
}

// MARK: - Macro Compilation Tests

final class MacroCompilationXCTests: XCTestCase {
    func testOnFreeFunctionCompiles() {
        `Macro Compilation Tests`.Integration().testOnFreeFunctionCompiles()
    }

    func testAsyncFunctionCompiles() async {
        await `Macro Compilation Tests`.Integration().testAsyncFunctionCompiles()
    }

    func testExpectWithBoolCompiles() {
        `Macro Compilation Tests`.Integration().expectWithBoolCompiles()
    }

    func testExpectWithCommentCompiles() {
        `Macro Compilation Tests`.Integration().expectWithCommentCompiles()
    }

    func testRequireWithBoolCompiles() throws {
        try `Macro Compilation Tests`.Integration().requireWithBoolCompiles()
    }

    func testRequireWithOptionalUnwrappingCompiles() throws {
        try `Macro Compilation Tests`.Integration().requireWithOptionalUnwrappingCompiles()
    }
}
// swiftlint:enable no_xctest_import no_xctestcase_subclass
