import Testing

@Suite
struct `Macro Support Test` {
    @Suite struct Unit {}
}

extension `Macro Support Test`.Unit {
    @Test
    func testIDResolvesToTestID() {
        let id = Observe.testID()
        #expect(id.name == "testFunc")
        #expect(id.module == "TestModule")
    }

    @Test
    func testSourceLocationResolvesToTestSourceLocation() {
        let location = Observe.testSourceLocation()
        #expect(location.line == "42")
        #expect(location.column == "10")
    }

    @Test
    func testTraitResolvesToTestTrait() {
        #expect(Observe.enabledTraitIsEnabledTrue(), "Expected .enabled(true) trait")
    }

    @Test
    func testBodyResolvesCorrectly() {
        #expect(Observe.syncTestBodyConstructs())
    }
}
