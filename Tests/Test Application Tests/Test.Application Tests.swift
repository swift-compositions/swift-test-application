// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-test-application open source project
//
// Copyright (c) 2026 Coen ten Thije Boonkkamp and the swift-test-application project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

import Test_Application
import Testing

@Suite
struct TestApplicationTests {
    @Test
    func capturesOutputAndStatus() throws {
        let receipt = try Test.Application.run(
            .init(command: .init(executable: "/usr/bin/printf", arguments: ["hello"]))
        )

        #expect(receipt.status == .exited(code: 0))
        #expect(receipt.standardOutput == Array("hello".utf8))
        #expect(receipt.standardError == [])
    }

    @Test
    func preservesArguments() throws {
        let receipt = try Test.Application.run(
            .init(command: .init(executable: "/bin/echo", arguments: ["one", "two"]))
        )

        #expect(receipt.standardOutput == Array("one two\n".utf8))
    }

    @Test
    func reportsNonzeroExitWithoutTreatingItAsLaunchFailure() throws {
        let receipt = try Test.Application.run(
            .init(command: .init(executable: "/usr/bin/false"))
        )

        #expect(receipt.status == .exited(code: 1))
    }
}
