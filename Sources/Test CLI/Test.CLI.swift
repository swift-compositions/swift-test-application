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

import Process
import Test_Application

@main
enum TestCLI {
    static func main() {
        do {
            let configuration = try Argument.configuration(
                from: Array(CommandLine.arguments.dropFirst())
            )
            let receipt = try Test.Application.run(configuration)

            if let bytes = receipt.standardOutput {
                Swift.print(Swift.String(decoding: bytes, as: UTF8.self), terminator: "")
            }
            if let bytes = receipt.standardError {
                Swift.print(Swift.String(decoding: bytes, as: UTF8.self), terminator: "")
            }

            switch receipt.status {
            case .exited(let code): Process.exit(code)
            case .signaled, .stopped: Process.exit(1)
            }
        } catch {
            Swift.print("usage: test-cli [--working-directory PATH] EXECUTABLE [ARGUMENT ...]")
            Process.exit(2)
        }
    }
}
