// This source file is part of the swift-test-application open source project
// Copyright (c) 2026 Coen ten Thije Boonkkamp and project authors
// Licensed under Apache License v2.0

public import Test

extension Test.Application {
    public enum Event: Sendable, Equatable {
        case started(Command)
        case finished(Receipt)
    }
}
