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

extension Test.Application {
    /// Configuration for one external test invocation.
    public struct Configuration: Sendable, Equatable {
        public let command: Command
        public let output: Output

        public init(command: Command, output: Output = .captured) {
            self.command = command
            self.output = output
        }
    }
}
