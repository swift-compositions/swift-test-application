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
    /// Failure to launch, wait for, or capture an external test process.
    public enum Error: Swift.Error, Sendable, Equatable {
        case process
    }
}
