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
    /// Child-process stream handling policy.
    public enum Output: Sendable, Equatable {
        case inherited
        case captured
    }
}
