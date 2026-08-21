import Environment
@testable import Test_CLI
import Test_Application
import Testing

enum Relation {}

extension Relation {
    @Suite struct Test {
        @Suite struct Unit {
            @Test func `arguments translate working directory environment and output`() throws {
                let configuration = try NeutralTest.CLI.Argument.configuration(
                    from: [
                        "--working-directory", "/tmp",
                        "--environment", "MODE=test",
                        "--inherit-output",
                        "/usr/bin/true",
                    ],
                    environment: .init(["BASE": "present"])
                )
                #expect(configuration.command.workingDirectory == "/tmp")
                #expect(configuration.command.environment?["BASE"] == "present")
                #expect(configuration.command.environment?["MODE"] == "test")
                #expect(configuration.output == .inherited)
            }
        }

        @Suite struct `Edge Case` {
            @Test func `unknown options are rejected`() {
                #expect(throws: NeutralTest.CLI.Argument.Error.self) {
                    try NeutralTest.CLI.Argument.configuration(from: ["--unknown"], environment: .init())
                }
            }
        }

        @Suite struct Integration {
            @Test func `CLI returns the child exit status`() {
                let status = NeutralTest.CLI.main(arguments: ["/usr/bin/true"], environment: .init())
                #expect(status == 0)
            }
        }
    }
}
