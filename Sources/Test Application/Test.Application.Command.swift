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

public import Environment
public import Test

extension Test.Application {
    /// A test command translated into an external process invocation.
    public struct Command: Sendable, Equatable {
        public let executable: Swift.String
        public let arguments: [Swift.String]
        public let environment: Environment.Snapshot?
        public let workingDirectory: Swift.String?
        public let timeout: Duration?

        public init(
            executable: Swift.String,
            arguments: [Swift.String] = [],
            environment: Environment.Snapshot? = nil,
            workingDirectory: Swift.String? = nil,
            timeout: Duration? = nil
        ) {
            self.executable = executable
            self.arguments = arguments
            self.environment = environment
            self.workingDirectory = workingDirectory
            self.timeout = timeout
        }
    }
}
