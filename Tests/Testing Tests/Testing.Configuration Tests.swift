import Testing

@Suite
struct `Configuration Test` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
}

extension `Configuration Test`.Unit {
    @Test
    func initCreatesDefaultConfigurationWithNilFilter() {
        #expect(Observe.defaultConfiguration().filter == nil)
    }

    @Test
    func initCreatesDefaultConfigurationWithNilTags() {
        #expect(Observe.defaultConfiguration().tagsIsNil)
    }

    @Test
    func initCreatesDefaultConfigurationWithAutomaticConcurrency() {
        #expect(Observe.defaultConfiguration().concurrencyIsAutomatic, "Expected .automatic concurrency")
    }

    @Test
    func initCreatesDefaultConfigurationWithTeeOutputFormat() {
        #expect(Observe.defaultConfiguration().formatIsTee, "Expected .tee output format")
    }

    @Test
    func initCreatesDefaultConfigurationWithNilOutputPath() {
        #expect(Observe.defaultConfiguration().outputPathIsNil)
    }

    @Test
    func stubFactoryCreatesConfigurationWithProvidedValues() {
        let config = Observe.stubConfiguration()
        #expect(config.filter == "MyTest")
        #expect(config.concurrencyIsSerial, "Expected .serial concurrency")
        #expect(config.formatIsJSON, "Expected .json output format")
    }
}

extension `Configuration Test`.`Edge Case` {
    @Test
    func currentWithNoEnvVarsReturnsDefaults() {
        #expect(Observe.currentConfiguration().outputPathIsNil)
    }
}
