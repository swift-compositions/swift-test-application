import Testing

@Suite
struct `Macro Compilation Tests` {
    @Suite struct Integration {}
}

extension `Macro Compilation Tests`.Integration {
    @Test
    func testOnFreeFunctionCompiles() {
    }

    @Test
    func testAsyncFunctionCompiles() async {
    }

    @Test
    func expectWithBoolCompiles() {
        Observe.instituteExpectWithBool()
    }

    @Test
    func expectWithCommentCompiles() {
        Observe.instituteExpectWithComment()
    }

    @Test
    func requireWithBoolCompiles() throws {
        try Observe.instituteRequireWithBool()
    }

    @Test
    func requireWithOptionalUnwrappingCompiles() throws {
        #expect(try Observe.instituteRequireWithOptionalUnwrapping() == 42)
    }
}
