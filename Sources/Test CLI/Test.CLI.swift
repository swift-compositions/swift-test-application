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

import Console
public import Environment_Core
import Test_Application
public import Test

extension Test {
    public enum CLI {}
}

extension Test.CLI {
    public static func main(
        arguments: [Swift.String],
        environment: Environment.Snapshot
    ) -> Int32 {
        let configuration: Test.Application.Configuration
        do throws(Test.CLI.Argument.Error) {
            configuration = try Argument.configuration(from: arguments, environment: environment)
        } catch {
            Console.Output.error("usage: test-cli [--working-directory PATH] [--environment KEY=VALUE] [--inherit-output] EXECUTABLE [ARGUMENT ...]\n")
            return 2
        }

        do throws(Test.Application.Error) {
            let receipt = try Test.Application.run(configuration)
            if let bytes = receipt.standardOutput {
                Swift.print(Swift.String(decoding: bytes, as: UTF8.self), terminator: "")
            }
            if let bytes = receipt.standardError {
                Console.Output.error(Swift.String(decoding: bytes, as: UTF8.self))
            }

            switch receipt.status {
            case .exited(let code): return code
            case .signaled, .stopped: return 1
            }
        } catch {
            Console.Output.error("test invocation failed: \(error)\n")
            return 2
        }
    }
}
