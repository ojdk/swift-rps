import Foundation

public protocol Dice {
    associatedtype RollResult
    func roll() -> RollResult
}
public struct D6: Dice {
    public typealias RollResult = Int

    public init() {}

    public func roll() -> Int {
        Int.random(in: 1...6)
    }
}
public struct D20: Dice {
    public typealias RollResult = Int

    public init() {}

    public func roll() -> Int {
        Int.random(in: 1...20)
    }
}
public struct DiceRoller<T: Dice> {
    private let dice: T

    public init(dice: T) {
        self.dice = dice
    }

    public func roll() -> T.RollResult {
        dice.roll()
    }
}
