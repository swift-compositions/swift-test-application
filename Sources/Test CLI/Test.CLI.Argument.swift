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

import Environment
import Test_Application
import Test

extension Test.CLI {
    enum Argument {}
}

extension Test.CLI.Argument {
    static func configuration(
        from arguments: [Swift.String],
        environment: Environment.Snapshot
    ) throws(Error) -> Test.Application.Configuration {
        var index = 0
        var workingDirectory: Swift.String?
        var inheritedOutput = false
        var environment = environment

        options: while arguments.indices.contains(index) {
            switch arguments[index] {
            case "--working-directory":
                guard arguments.indices.contains(index + 1) else { throw .missingWorkingDirectory }
                workingDirectory = arguments[index + 1]
                index += 2
            case "--environment":
                guard arguments.indices.contains(index + 1) else { throw .missingEnvironment }
                let pair = arguments[index + 1].split(separator: "=", maxSplits: 1, omittingEmptySubsequences: false)
                guard pair.count == 2, !pair[0].isEmpty else { throw .invalidEnvironment }
                environment[Swift.String(pair[0])] = Swift.String(pair[1])
                index += 2
            case "--inherit-output":
                inheritedOutput = true
                index += 1
            default:
                if arguments[index].hasPrefix("--") { throw .unknownOption(arguments[index]) }
                break options
            }
        }

        guard arguments.indices.contains(index) else {
            throw .missingExecutable
        }

        return Test.Application.Configuration(
            command: .init(
                executable: arguments[index],
                arguments: Array(arguments.dropFirst(index + 1)),
                environment: environment,
                workingDirectory: workingDirectory
            ),
            output: inheritedOutput ? .inherited : .captured
        )
    }
}
