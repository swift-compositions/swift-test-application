// This source file is part of the swift-test-application open source project
// Copyright (c) 2026 Coen ten Thije Boonkkamp and project authors
// Licensed under Apache License v2.0

import Environment
import Process
import Test_Application
import Test

@main
enum Entry {}

extension Entry {
    static func main() {
        Process.exit(
            Test.CLI.main(
                arguments: Array(CommandLine.arguments.dropFirst()),
                environment: .current()
            )
        )
    }
}
