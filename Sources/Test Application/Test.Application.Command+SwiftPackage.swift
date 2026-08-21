// This source file is part of the swift-test-application open source project
// Copyright (c) 2026 Coen ten Thije Boonkkamp and project authors
// Licensed under Apache License v2.0

public import Environment
public import Test

extension Test.Application.Command {
    public static func swiftPackage(
        at packagePath: String,
        filter: String? = nil,
        environment: Environment.Snapshot? = nil,
        arguments additionalArguments: [String] = []
    ) -> Self {
        var arguments = ["test", "--package-path", packagePath]
        if let filter { arguments += ["--filter", filter] }
        arguments += additionalArguments
        return .init(executable: "swift", arguments: arguments, environment: environment)
    }
}
