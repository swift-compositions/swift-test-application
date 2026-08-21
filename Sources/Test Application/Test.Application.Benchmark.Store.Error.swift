// This source file is part of the swift-test-application open source project
// Copyright (c) 2026 Coen ten Thije Boonkkamp and project authors
// Licensed under Apache License v2.0

public import File_System_Core
public import JSON
public import Test

extension Test.Application.Benchmark.Store {
    public enum Error: Swift.Error, Sendable {
        case read(File.System.Read.Full.Error)
        case write(File.System.Write.Streaming.Error)
        case json(JSON.Error)
    }
}
