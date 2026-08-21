// This source file is part of the swift-test-application open source project
// Copyright (c) 2026 Coen ten Thije Boonkkamp and project authors
// Licensed under Apache License v2.0

public import Environment
public import Test

extension Test.Application.Command {
    public static func xcode(
        workspace: String,
        scheme: String,
        destination: String? = nil,
        environment: Environment.Snapshot? = nil,
        arguments additionalArguments: [String] = []
    ) -> Self {
        var arguments = ["test", "-workspace", workspace, "-scheme", scheme]
        if let destination { arguments += ["-destination", destination] }
        arguments += additionalArguments
        return .init(executable: "xcodebuild", arguments: arguments, environment: environment)
    }
}
