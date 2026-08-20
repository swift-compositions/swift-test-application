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

import Test_Application

enum Argument {}

extension Argument {
    static func configuration(
        from arguments: [Swift.String]
    ) throws(ArgumentError) -> Test.Application.Configuration {
        var index = 0
        var workingDirectory: Swift.String?

        if arguments.first == "--working-directory" {
            guard arguments.count > 1 else {
                throw .missingWorkingDirectory
            }
            workingDirectory = arguments[1]
            index = 2
        }

        guard arguments.indices.contains(index) else {
            throw .missingExecutable
        }

        return Test.Application.Configuration(
            command: .init(
                executable: arguments[index],
                arguments: Array(arguments.dropFirst(index + 1)),
                workingDirectory: workingDirectory
            )
        )
    }
}
