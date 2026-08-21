# swift-test-application

External test-process orchestration for Swift.

`swift-test-application` translates test commands into child processes and returns typed receipts containing the exit status and captured output. It also owns terminal and structured reporting plus versioned benchmark-reference persistence. It does not define test macros, discover tests, or run tests in-process; Apple Testing and the selected build tool retain those responsibilities.

## Products

- `Test Application` provides `Test.Application` command, configuration, execution, event, reporting, receipt, and benchmark-store types.
- `Test CLI` translates command-line arguments and environment into a `Test.Application` invocation.

## Installation

Add the package dependency while the package is pre-release:

```swift
.package(
    url: "https://github.com/swift-foundations/swift-test-application.git",
    branch: "main"
)
```

Add the library product to an application or tool target:

```swift
.product(
    name: "Test Application",
    package: "swift-test-application"
)
```

## Usage

```swift
import Test_Application

let receipt = try Test.Application.run(
    .init(
        command: .init(
            executable: "swift",
            arguments: ["test"],
            workingDirectory: "/path/to/package"
        )
    )
)

print(Test.Application.Report.terminal(receipt), terminator: "")

switch receipt.status {
case .exited(code: 0):
    print("tests passed")
default:
    print("tests did not pass")
}
```

Use the command factories when the selected build tool should remain explicit:

```swift
let swiftPackage = Test.Application.Command.swiftPackage(
    at: "/path/to/package",
    arguments: ["--parallel"]
)

let xcode = Test.Application.Command.xcode(
    workspace: "/path/to/project/Example.xcworkspace",
    scheme: "Example"
)
```

The command-line product accepts a working directory, repeated environment overrides, optional inherited output, and then the executable plus its arguments:

```sh
test-cli \
  --working-directory /path/to/package \
  --environment SWIFT_DETERMINISTIC_HASHING=1 \
  --inherit-output \
  swift test
```

## Reporting and benchmark references

`Test.Application.Report.structured(_:)` produces a versioned JSON receipt. A `Test.Application.Reporter` receives ordered `.started` and `.finished` events without installing mutable global handlers.

`Test.Application.Benchmark.Store` persists `Benchmark.Baseline<JSON>` and `Benchmark.History<JSON>` as versioned JSON documents. Writes use the canonical file-system owner's atomic streaming operation; reads reject a mismatched schema or document kind.

## Error handling

`Test.Application.run(_:)` throws `Test.Application.Error.process` only when the child cannot be launched, captured, or waited for. A child that exits with a nonzero code still produces a receipt, allowing callers to distinguish infrastructure failures from test failures.

## Requirements

- Swift 6.4+
- macOS 27+, iOS 27+, tvOS 27+, watchOS 27+, or visionOS 27+

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
