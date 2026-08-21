import Synchronization
import Application_Primitives
import Benchmark
import Cardinal_Primitive
import File_System_Core
import JSON
import Test_Application
import Testing

enum Relation {}

extension Relation {
    @Suite struct Test {
        @Suite struct Unit {
            @Test func `receipt classifies process outcomes`() {
                #expect(NeutralTest.Application.Receipt(status: .exited(code: 0)).outcome == .passed)
                #expect(NeutralTest.Application.Receipt(status: .exited(code: 7)).outcome == .failed(code: 7))
                #expect(NeutralTest.Application.Receipt(status: .signaled(signal: 9)).outcome == .interrupted(signal: 9))
            }

            @Test func `reports have terminal and structured forms`() {
                let receipt = NeutralTest.Application.Receipt(
                    status: .exited(code: 0),
                    standardOutput: Array("hello".utf8),
                    standardError: []
                )
                #expect(NeutralTest.Application.Report.terminal(receipt) == "Test process passed\n")
                let json = NeutralTest.Application.Report.structured(receipt).serialize(sortKeys: true)
                #expect(json.contains("\"schema\":1"))
                #expect(json.contains("hello"))
            }
        }

        @Suite struct `Edge Case` {
            @Test func `nonzero exit remains a receipt rather than launch failure`() throws {
                let receipt = try NeutralTest.Application.run(
                    .init(command: .init(executable: "/usr/bin/false"))
                )
                #expect(receipt.outcome == .failed(code: 1))
            }

            @Test func `timeout interrupts a child process`() throws {
                let receipt = try NeutralTest.Application.run(
                    .init(command: .init(executable: "/bin/sleep", arguments: ["1"], timeout: .milliseconds(20)))
                )
                guard case .interrupted = receipt.outcome else {
                    Issue.record("Expected the timeout watchdog to interrupt the child")
                    return
                }
            }
        }

        @Suite struct Integration {
            @Test func `baseline and history persist as versioned JSON`() throws {
                let path = try File.Path.Temporary.sibling(
                    of: File.Path("/tmp/test-application-reference"),
                    prefix: "test-application-",
                    suffix: ".json"
                )
                defer {
                    do throws(File.System.Delete.Error) {
                        try File.System.Delete.delete(at: path)
                    } catch {}
                }

                let store = NeutralTest.Application.Benchmark.Store(path: path)
                let baseline = Benchmark.Baseline(name: "latency", value: JSON.number(42))
                try store.write(baseline)
                #expect(try store.baseline() == baseline)

                let history = Benchmark.History<JSON>(entries: [
                    .init(sequence: Cardinal(2), value: .number(42)),
                    .init(sequence: Cardinal(1), value: .number(41)),
                ])
                try store.write(history)
                #expect(try store.history() == history)
            }

            @Test func `run captures arguments and emits ordered events`() throws {
                let events = Mutex<[NeutralTest.Application.Event]>([])
                let receipt = try NeutralTest.Application.run(
                    .init(command: .init(executable: "/usr/bin/printf", arguments: ["%s", "hello"])),
                    reporter: .init(receive: { event in events.withLock { $0.append(event) } })
                )
                #expect(receipt.standardOutput == Array("hello".utf8))
                #expect(events.withLock { $0.count } == 2)
                #expect(events.withLock { if case .started = $0.first { true } else { false } })
                #expect(events.withLock { if case .finished = $0.last { true } else { false } })
            }

            @Test func `invocation carries the canonical application task boundary`() {
                let invocation = NeutralTest.Application.Invocation(
                    configuration: .init(command: .init(executable: "/usr/bin/true"))
                )
                #expect(invocation.boundary == .task)
            }
        }
    }
}
