// This source file is part of the swift-test-application open source project
// Copyright (c) 2026 Coen ten Thije Boonkkamp and project authors
// Licensed under Apache License v2.0

public import Benchmark
internal import Cardinal_Primitive
public import JSON
public import Test

extension Test.Application.Benchmark.Store {
    public func write(
        _ history: _BenchmarkAuthority.History<JSON>
    ) throws(Error) {
        let entries = history.entries.map {
            JSON.object([
                ("sequence", .string(String($0.sequence.rawValue))),
                ("value", $0.value),
            ])
        }
        try write(
            document: .object([
                ("schema", .number(1)),
                ("kind", .string("history")),
                ("entries", .array(entries)),
            ])
        )
    }

    public func history() throws(Error) -> _BenchmarkAuthority.History<JSON> {
        let document = try readDocument()
        guard Int(document.schema) == 1 else {
            throw .json(.typeMismatch(expected: "schema 1", got: document.schema.serialize()))
        }
        guard String(document.kind) == "history" else {
            throw .json(.typeMismatch(expected: "history", got: String(document.kind)))
        }
        guard let documents = document.entries.array else {
            throw .json(.typeMismatch(expected: "array", got: document.entries.serialize()))
        }

        var entries: [_BenchmarkAuthority.History<JSON>.Entry] = []
        entries.reserveCapacity(documents.count)
        for document in documents {
            guard document.sequence.isString,
                let sequence = UInt(String(document.sequence))
            else {
                throw .json(
                    .typeMismatch(
                        expected: "unsigned sequence string",
                        got: document.sequence.serialize()
                    )
                )
            }
            entries.append(.init(sequence: Cardinal(sequence), value: document.value))
        }
        return .init(entries: entries)
    }
}
