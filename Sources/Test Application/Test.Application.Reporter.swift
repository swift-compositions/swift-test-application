// This source file is part of the swift-test-application open source project
// Copyright (c) 2026 Coen ten Thije Boonkkamp and project authors
// Licensed under Apache License v2.0

public import Test

extension Test.Application {
    public struct Reporter: Sendable {
        private let receive: @Sendable (Event) -> Void

        public init(receive: @escaping @Sendable (Event) -> Void) {
            self.receive = receive
        }
    }
}

extension Test.Application.Reporter {
    public static let discarded = Self(receive: { _ in })

    public func callAsFunction(_ event: Test.Application.Event) {
        receive(event)
    }
}
