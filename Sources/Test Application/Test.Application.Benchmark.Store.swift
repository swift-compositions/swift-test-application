// This source file is part of the swift-test-application open source project
// Copyright (c) 2026 Coen ten Thije Boonkkamp and project authors
// Licensed under Apache License v2.0

public import File_System_Core
public import Test

extension Test.Application.Benchmark {
    /// One versioned JSON document stored through the canonical file-system owner.
    public struct Store: Sendable {
        public let path: File.Path

        public init(path: File.Path) {
            self.path = path
        }
    }
}
