// This source file is part of the swift-test-application open source project
// Copyright (c) 2026 Coen ten Thije Boonkkamp and project authors
// Licensed under Apache License v2.0

public import Test

extension Test.Application {
    public enum Outcome: Sendable, Equatable, Hashable {
        case passed
        case failed(code: Int32)
        case interrupted(signal: Int32)
        case stopped(signal: Int32)
    }
}
