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
import Test

extension Test.CLI.Argument {
    enum Error: Swift.Error, Sendable, Equatable {
        case invalidEnvironment
        case missingEnvironment
        case missingExecutable
        case missingWorkingDirectory
        case unknownOption(Swift.String)
    }
}
