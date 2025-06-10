import Foundation
import Vapor

/// Represents the JSON response body for a die roll result from the Core API, containing individual rolls.
struct DieRollResultPayload: Content, Codable {
  let rolls: [Int]  // Changed from a single result to an array of rolls
}

final class CoreApiController: Sendable {
  let app: Application

  init(app: Application) {
    self.app = app
  }

  func rollDice(_ req: Request) async throws -> DieRollResultPayload {

    // bad code force unwrap to early ...
    let dieType: String = req.parameters.get("dieType")!
    let count: Int = req.parameters.get("count")!

    app.logger.info(
      "rollDice called with dieType: \(dieType), count: \(count)"
    )

    // Validate and parse dieType (e.g., "d6" -> 6 sides)
    guard dieType.lowercased().starts(with: "d") else {
      throw Abort(.badRequest, reason: "Invalid die type format. Must start with 'd'.")
    }
    guard let sides = Int(dieType.dropFirst()), sides > 0 else {
      throw Abort(
        .badRequest, reason: "Invalid die type. Number of sides must be a positive integer.")
    }

    // Validate count
    guard count > 0 else {
      throw Abort(.badRequest, reason: "Number of dice to roll (count) must be positive.")
    }

    // Perform dice rolls
    var individualRolls: [Int] = []
    var totalSumForLogging = 0  // Keep sum for logging purposes if desired
    for _ in 0..<count {
      let roll = Int.random(in: 1...sides)
      individualRolls.append(roll)
      totalSumForLogging += roll
    }

    app.logger.info(
      "Rolled \(count) )\(dieType): \(individualRolls) -> Total: \(totalSumForLogging)"
    )

    return DieRollResultPayload(rolls: individualRolls)
  }

}
