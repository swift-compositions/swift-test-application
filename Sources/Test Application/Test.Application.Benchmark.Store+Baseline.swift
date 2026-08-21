// This source file is part of the swift-test-application open source project
// Copyright (c) 2026 Coen ten Thije Boonkkamp and project authors
// Licensed under Apache License v2.0

public import Benchmark
public import JSON
public import Test

extension Test.Application.Benchmark.Store {
    public func write(
        _ baseline: _BenchmarkAuthority.Baseline<JSON>
    ) throws(Error) {
        try write(
            document: .object([
                ("schema", .number(1)),
                ("kind", .string("baseline")),
                ("name", .string(baseline.name)),
                ("value", baseline.value),
            ])
        )
    }

    public func baseline() throws(Error) -> _BenchmarkAuthority.Baseline<JSON> {
        let document = try readDocument()
        guard Int(document.schema) == 1 else {
            throw .json(.typeMismatch(expected: "schema 1", got: document.schema.serialize()))
        }
        guard String(document.kind) == "baseline" else {
            throw .json(.typeMismatch(expected: "baseline", got: String(document.kind)))
        }
        guard document.name.isString else {
            throw .json(.typeMismatch(expected: "string", got: document.name.serialize()))
        }
        return .init(name: String(document.name), value: document.value)
    }
}
