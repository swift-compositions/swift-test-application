import Testing

@Suite
struct `MacroSpec Consumer Tests` {
    @Test
    func `two macro types in one specification dictionary expand`() {
        #expect(MacroSpecConsumer.expandsBothMacros())
    }

    @Test
    func `a wrong expected expansion is reported as a failure`() {
        #expect(MacroSpecConsumer.rejectsAWrongExpansion())
    }
}
