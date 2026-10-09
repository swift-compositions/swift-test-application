import SwiftSyntax
import SwiftSyntaxMacroExpansion
import SwiftSyntaxMacros
import Test
import Test_Application

enum MacroSpecConsumer {
    enum One: ExpressionMacro {
        static func expansion(
            of node: some FreestandingMacroExpansionSyntax,
            in context: some MacroExpansionContext
        ) -> ExprSyntax {
            ExprSyntax(IntegerLiteralExprSyntax(literal: .integerLiteral("1")))
        }
    }

    enum Flag: ExpressionMacro {
        static func expansion(
            of node: some FreestandingMacroExpansionSyntax,
            in context: some MacroExpansionContext
        ) -> ExprSyntax {
            ExprSyntax(BooleanLiteralExprSyntax(literal: .keyword(.true)))
        }
    }

    static let specs: [Swift.String: MacroSpec] = [
        "one": MacroSpec(type: One.self),
        "flag": MacroSpec(type: Flag.self),
    ]

    static func expandsBothMacros() -> Bool {
        do throws(Test::Test.Requirement.Failed) {
            try assertMacroExpansion(
                "let value = (#one, #flag)",
                expandedSource: "let value = (1, true)",
                macroSpecs: specs
            )
            return true
        } catch {
            return false
        }
    }

    static func rejectsAWrongExpansion() -> Bool {
        do throws(Test::Test.Requirement.Failed) {
            try assertMacroExpansion(
                "let value = (#one, #flag)",
                expandedSource: "let value = (2, true)",
                macroSpecs: specs
            )
            return false
        } catch {
            return true
        }
    }
}
