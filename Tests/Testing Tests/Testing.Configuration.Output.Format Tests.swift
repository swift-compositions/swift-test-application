import Testing

@Suite
struct `Configuration Output Format Test` {
    @Suite struct Unit {}
}

extension `Configuration Output Format Test`.Unit {
    @Test
    func consoleAndJsonCasesAreDistinct() {
        let observed = Observe.outputFormatSwitch()
        #expect(!observed.consoleMatchesJSON, "Console should not match json")
        #expect(!observed.jsonMatchesConsole, "JSON should not match console")
    }
}
