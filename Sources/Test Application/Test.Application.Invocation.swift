// This source file is part of the swift-test-application open source project
// Copyright (c) 2026 Coen ten Thije Boonkkamp and project authors
// Licensed under Apache License v2.0

public import Test
public import Application_Primitives

extension Test.Application {
    /// One external test execution at the canonical application task boundary.
    public struct Invocation: Sendable, Equatable {
        public let configuration: Configuration
        public let boundary: _ApplicationAuthority.Boundary

        public init(
            configuration: Configuration,
            boundary: _ApplicationAuthority.Boundary = .task
        ) {
            self.configuration = configuration
            self.boundary = boundary
        }
    }
}
