# swift-test-application

External test-process orchestration for Swift.

`swift-test-application` translates test commands into child processes and returns typed receipts containing the exit status and captured output. It does not define test macros, discover tests, or run tests in-process; Apple Testing and the selected build tool retain those responsibilities.

## Products

- `Test Application` provides `Test.Application` command, configuration, execution, and receipt types.
- `Test CLI` translates command-line arguments into a `Test.Application` invocation.

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

switch receipt.status {
case .exited(code: 0):
    print("tests passed")
default:
    print("tests did not pass")
}
```

The command-line product accepts an optional working directory followed by the executable and its arguments:

```sh
test-cli --working-directory /path/to/package swift test
```

## Error handling

`Test.Application.run(_:)` throws `Test.Application.Error.process` only when the child cannot be launched, captured, or waited for. A child that exits with a nonzero code still produces a receipt, allowing callers to distinguish infrastructure failures from test failures.

## Requirements

- Swift 6.4+
- macOS 27+, iOS 27+, tvOS 27+, watchOS 27+, or visionOS 27+

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
