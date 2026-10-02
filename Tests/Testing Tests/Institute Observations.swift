import Test
import Test_Application
import Testing_Test_Support

enum Observe {
    static func expectTrueIsPassing() -> Bool {
        Testing.__expect(true).isPassing
    }

    static func expectFalseInCollectorIsFailing() -> Bool {
        let collector = Test.Expectation.Collector()
        let expectation = Test.Expectation.Collector.with(collector) {
            Testing.__expect(false)
        }
        return expectation.isFailing
    }

    static func requireTrue() throws {
        try Testing.__require(true)
    }

    static func requireUnwrapping(_ value: Int?) throws -> Int {
        try Testing.__require(value)
    }

    static func requireFalseInCollectorThrows() -> Bool {
        let collector = Test.Expectation.Collector()
        do {
            try Test.Expectation.Collector.with(collector) {
                try Testing.__require(false)
            }
            return false
        } catch {
            return true
        }
    }

    static func requireNilInCollectorThrows() -> Bool {
        let value: Int? = nil
        let collector = Test.Expectation.Collector()
        do {
            _ = try Test.Expectation.Collector.with(collector) {
                try Testing.__require(value)
            }
            return false
        } catch {
            return true
        }
    }
}

extension Observe {
    static func testID() -> (name: Swift.String, module: Swift.String) {
        let id = Testing.__TestID(
            module: "TestModule",
            name: "testFunc",
            sourceLocation: .init(
                fileID: "test/file.swift",
                filePath: "/test/file.swift",
                line: 1,
                column: 1
            )
        )
        return (name: id.name, module: id.module)
    }

    static func testSourceLocation() -> (line: Swift.String, column: Swift.String) {
        let location = Testing.__TestSourceLocation(
            fileID: "module/file.swift",
            filePath: "/path/to/file.swift",
            line: 42,
            column: 10
        )
        return (line: "\(location.line)", column: "\(location.column)")
    }

    static func enabledTraitIsEnabledTrue() -> Bool {
        let trait: Testing.__TestTrait = .enabled(if: true)
        if case .enabled(true, _) = trait.kind {
            return true
        }
        return false
    }

    static func syncTestBodyConstructs() -> Bool {
        let body: Testing.__TestBody = .sync {}
        _ = body
        return true
    }
}

extension Observe {
    struct Configuration {
        let filter: Swift.String?
        let tagsIsNil: Bool
        let concurrencyIsAutomatic: Bool
        let concurrencyIsSerial: Bool
        let formatIsTee: Bool
        let formatIsJSON: Bool
        let outputPathIsNil: Bool

        init(_ config: Testing.Configuration) {
            filter = config.filter
            tagsIsNil = config.tags == nil
            if case .automatic = config.concurrency { concurrencyIsAutomatic = true } else { concurrencyIsAutomatic = false }
            if case .serial = config.concurrency { concurrencyIsSerial = true } else { concurrencyIsSerial = false }
            if case .tee = config.output.format { formatIsTee = true } else { formatIsTee = false }
            if case .json = config.output.format { formatIsJSON = true } else { formatIsJSON = false }
            outputPathIsNil = config.output.path == nil
        }
    }

    static func defaultConfiguration() -> Configuration {
        Configuration(Testing.Configuration())
    }

    static func stubConfiguration() -> Configuration {
        Configuration(
            Testing.Configuration.stub(
                filter: "MyTest",
                concurrency: .serial,
                output: .init(format: .json)
            )
        )
    }

    static func currentConfiguration() -> Configuration {
        Configuration(Testing.Configuration.current)
    }

    static func outputFormatSwitch() -> (consoleMatchesJSON: Bool, jsonMatchesConsole: Bool) {
        let console = Testing.Configuration.Output.Format.console
        let json = Testing.Configuration.Output.Format.json
        var config = Testing.Configuration()
        config.output.format = console
        var consoleMatchesJSON = false
        if case .json = config.output.format { consoleMatchesJSON = true }
        config.output.format = json
        var jsonMatchesConsole = false
        if case .console = config.output.format { jsonMatchesConsole = true }
        return (consoleMatchesJSON, jsonMatchesConsole)
    }

    static func discoverSections() {
        let registry = Testing.Discovery.sections()
        _ = registry
    }

    static func discoverAll() {
        let registry = Testing.Discovery.all()
        _ = registry
    }
}

extension Observe {
    static func instituteExpectWithBool() {
        #expect(true)
    }

    static func instituteExpectWithComment() {
        #expect(true, "always true")
    }

    static func instituteRequireWithBool() throws {
        try #require(true)
    }

    static func instituteRequireWithOptionalUnwrapping() throws -> Int {
        let value: Int? = 42
        let unwrapped = try #require(value)
        #expect(unwrapped == 42)
        return unwrapped
    }
}
