import Testing

@Suite
struct `Discovery Test` {
    @Suite struct Integration {}
}

extension `Discovery Test`.Integration {
    @Test
    func sectionsReturnsARegistry() {
        Observe.discoverSections()
    }

    @Test
    func allReturnsARegistry() {
        Observe.discoverAll()
    }
}
