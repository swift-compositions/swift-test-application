// This source file is part of the swift-test-application open source project
// Copyright (c) 2026 Coen ten Thije Boonkkamp and project authors
// Licensed under Apache License v2.0

public import Test

extension Test.Application.Receipt {
    /// Platform-neutral terminal state of the external test process.
    public enum Status: Sendable, Equatable, Hashable {
        case exited(code: Int32)
        case signaled(signal: Int32)
        case stopped(signal: Int32)
    }
}
