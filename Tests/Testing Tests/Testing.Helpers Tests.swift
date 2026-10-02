import Testing

@Suite
struct `Helpers Test` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
}

extension `Helpers Test`.Unit {
    @Test
    func expectWithTrueReturnsPassingExpectation() {
        #expect(Observe.expectTrueIsPassing())
    }

    @Test
    func expectWithFalseReturnsFailingExpectation() {
        #expect(Observe.expectFalseInCollectorIsFailing())
    }

    @Test
    func requireWithTrueDoesNotThrow() throws {
        try Observe.requireTrue()
    }

    @Test
    func requireWithNonNilOptionalReturnsUnwrappedValue() throws {
        let unwrapped = try Observe.requireUnwrapping(42)
        #expect(unwrapped == 42)
    }
}

extension `Helpers Test`.`Edge Case` {
    @Test
    func requireWithFalseThrows() {
        #expect(Observe.requireFalseInCollectorThrows(), "Expected __require(false) to throw")
    }

    @Test
    func requireWithNilOptionalThrows() {
        #expect(Observe.requireNilInCollectorThrows(), "Expected __require(nil) to throw")
    }
}
