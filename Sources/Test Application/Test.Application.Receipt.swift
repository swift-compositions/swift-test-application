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

public import Test

extension Test.Application {
    /// Facts returned by an external test invocation.
    public struct Receipt: Sendable, Equatable {
        public let status: Status
        public let standardOutput: [UInt8]?
        public let standardError: [UInt8]?

        public init(
            status: Status,
            standardOutput: [UInt8]? = nil,
            standardError: [UInt8]? = nil
        ) {
            self.status = status
            self.standardOutput = standardOutput
            self.standardError = standardError
        }
    }
}

extension Test.Application.Receipt {
    public var outcome: Test.Application.Outcome {
        switch status {
        case .exited(code: 0): .passed
        case .exited(let code): .failed(code: code)
        case .signaled(let signal): .interrupted(signal: signal)
        case .stopped(let signal): .stopped(signal: signal)
        }
    }
}
