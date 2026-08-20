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

internal import Process

extension Test.Application {
    /// Runs the configured external test process and returns its receipt.
    public static func run(
        _ configuration: Configuration
    ) throws(Test.Application.Error) -> Receipt {
        let stream: Process.Stream = switch configuration.output {
        case .inherited: .inherit
        case .captured: .pipe
        }

        let process = Process.Spawn.Configuration(
            executable: configuration.command.executable,
            arguments: configuration.command.arguments,
            environment: configuration.command.environment,
            stdout: stream,
            stderr: stream,
            workingDirectory: configuration.command.workingDirectory,
            timeout: configuration.command.timeout
        )

        do throws(Process.Error) {
            let output = try Process.Spawn.run(process)
            let status: Receipt.Status = switch output.status {
            case .exited(let code): .exited(code: code)
            case .signaled(let signal): .signaled(signal: signal)
            case .stopped(let signal): .stopped(signal: signal)
            }
            return Receipt(
                status: status,
                standardOutput: output.stdout,
                standardError: output.stderr
            )
        } catch {
            throw .process
        }
    }
}
