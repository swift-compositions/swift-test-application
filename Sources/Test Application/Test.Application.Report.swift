// This source file is part of the swift-test-application open source project
// Copyright (c) 2026 Coen ten Thije Boonkkamp and project authors
// Licensed under Apache License v2.0

public import JSON
public import Test

extension Test.Application {
    public enum Report {}
}

extension Test.Application.Report {
    public static func terminal(_ receipt: Test.Application.Receipt) -> String {
        let status = switch receipt.outcome {
        case .passed: "passed"
        case .failed(let code): "failed (exit \(code))"
        case .interrupted(let signal): "interrupted (signal \(signal))"
        case .stopped(let signal): "stopped (signal \(signal))"
        }
        return "Test process \(status)\n"
    }

    public static func structured(_ receipt: Test.Application.Receipt) -> JSON {
        let status: JSON = switch receipt.status {
        case .exited(let code): .object([("kind", .string("exited")), ("code", .number(Int(code)))])
        case .signaled(let signal): .object([("kind", .string("signaled")), ("signal", .number(Int(signal)))])
        case .stopped(let signal): .object([("kind", .string("stopped")), ("signal", .number(Int(signal)))])
        }
        return .object([
            ("schema", .number(1)),
            ("status", status),
            ("standardOutput", receipt.standardOutput.map { .string(String(decoding: $0, as: UTF8.self)) } ?? .null),
            ("standardError", receipt.standardError.map { .string(String(decoding: $0, as: UTF8.self)) } ?? .null),
        ])
    }
}
