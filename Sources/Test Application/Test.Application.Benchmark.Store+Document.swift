// This source file is part of the swift-test-application open source project
// Copyright (c) 2026 Coen ten Thije Boonkkamp and project authors
// Licensed under Apache License v2.0

internal import Byte_Primitive
internal import Either_Primitives
internal import File_System_Core
internal import JSON
internal import Test

extension Test.Application.Benchmark.Store {
    func write(document: JSON) throws(Error) {
        let bytes = document.serialize(sortKeys: true).utf8.map(Byte.init)
        do throws(File.System.Write.Streaming.Error) {
            try File.System.Write.Streaming.write(
                bytes,
                to: path,
                createIntermediates: true
            )
        } catch {
            throw .write(error)
        }
    }

    func readDocument() throws(Error) -> JSON {
        do throws(Either<File.System.Read.Full.Error, JSON.Error>) {
            return try File.System.Read.Full.read(from: path) {
                (span: Swift.Span<Byte>) throws(JSON.Error) in
                var bytes: [Byte] = []
                bytes.reserveCapacity(span.count)
                for index in span.indices {
                    bytes.append(span[index])
                }
                return try JSON.parse(bytes)
            }
        } catch {
            switch error {
            case .left(let failure): throw .read(failure)
            case .right(let failure): throw .json(failure)
            }
        }
    }
}
