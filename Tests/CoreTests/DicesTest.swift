import XCTest

@testable import Core  // Assuming your Dices.swift is in a module named "Core"

class D6Tests: XCTestCase {

    func testD6RollReturnsValueInRange() {
        // Arrange
        let d6 = D6()

        // Act & Assert
        // Roll multiple times to increase confidence that it stays within range
        for _ in 0..<100 {
            let result = d6.roll()
            XCTAssertTrue(
                (1...6).contains(result), "D6 roll should be between 1 and 6, but was \(result)")
        }
    }
}
class D20Tests: XCTestCase {

    func testD20RollReturnsValueInRange() {
        // Arrange
        let d20 = D20()

        // Act & Assert
        for _ in 0..<100 {
            let result = d20.roll()
            XCTAssertTrue(
                (1...20).contains(result), "D20 roll should be between 1 and 20, but was \(result)")
        }
    }
}
class DiceRollerTests: XCTestCase {

    // A mock Dice implementation for testing DiceRoller in isolation
    class MockDice: Dice {

        var expectedRollResult: RollResult
        var rollCalledCount = 0

        init(expectedRollResult: Int) {
            self.expectedRollResult = expectedRollResult
        }

        func roll() -> Int {
            rollCalledCount += 1
            return expectedRollResult
        }
    }

    func testDiceRollerWithD6() {
        // Arrange
        let d6 = D6()  // Using a real D6
        let roller = DiceRoller(dice: d6)

        // Act & Assert
        for _ in 0..<50 {  // Test a few rolls
            let result = roller.roll()
            XCTAssertTrue(
                (1...6).contains(result),
                "DiceRoller with D6 should produce a D6 result, but got \(result)")
        }
    }

    func testDiceRollerUsesProvidedDice() {
        // Arrange
        let mockDice = MockDice(expectedRollResult: 13)  // Our mock dice will always return 13
        let roller = DiceRoller(dice: mockDice)

        // Act
        let result = roller.roll()

        // Assert
        XCTAssertEqual(
            result, 13, "DiceRoller should return the result from the provided mock dice.")
        XCTAssertEqual(
            mockDice.rollCalledCount, 1,
            "The mock dice's roll() method should have been called once.")

        // Act again
        _ = roller.roll()

        // Assert again
        XCTAssertEqual(
            mockDice.rollCalledCount, 2,
            "The mock dice's roll() method should have been called twice.")
    }
}
