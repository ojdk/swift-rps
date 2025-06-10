import Foundation
import Vapor

// These can be defined here or in a separate Models file.

/// Represents the JSON request body for creating a monster.
struct MonsterCreationRequest: Content, Codable {  // Use Vapor's Content for automatic decoding
  let name: String
  let type: String
  let requestedLevel: Int?
}

/// Represents the JSON response body describing the created monster.
struct MonsterResponse: Content, Codable {  // Use Vapor's Content for automatic encoding
  let id: UUID
  let name: String
  let type: String
  let level: Int
  let hits: [Int]
  let createdAt: Date
}

/// Represents the JSON response body from the CoreBook API for a die roll, expecting an array of rolls.
struct DieRollResponse: Content, Codable {
  let rolls: [Int]  // Updated to expect an array of rolls
}

final class MonsterApiController: Sendable {

  let app: Application

  let corebookHostname: String
  let corebookPort: Int

  init(app: Application, corebookHostname: String, corebookPort: Int) {
    self.app = app
    self.corebookHostname = corebookHostname
    self.corebookPort = corebookPort
  }

  func getMonster(_ req: Request) async throws -> MonsterResponse {
    app.logger.info(
      "getMonster called")
    let creationRequest: MonsterCreationRequest = try req.content.get(MonsterCreationRequest.self)
    app.logger.info(
      "getMonster called with name: \(creationRequest.name), type: \(creationRequest.type)")

    // --- Business logic for creating a monster would go here ---
    // For now, we'll just simulate it.

    // Call CoreBook API to get hits values
    let coreBookApiUrl: String = "http://\(corebookHostname):\(corebookPort)/roll/d6/4"
    app.logger.info("Calling CoreBook API at \(coreBookApiUrl)")

    let dieRollResponse: DieRollResponse
    do {
      let coreBookResponse: ClientResponse = try await req.client.get(URI(string: coreBookApiUrl))
      // Check for successful status code (e.g., 200 OK)
      guard coreBookResponse.status == .ok else {
        app.logger.error("CoreBook API returned non-OK status: \(coreBookResponse.status)")
        throw Abort(
          .internalServerError,
          reason:
            "Failed to get die roll from CoreBook API: Received status \(coreBookResponse.status)")
      }
      dieRollResponse = try coreBookResponse.content.decode(DieRollResponse.self)
      app.logger.info("Received die rolls: \(dieRollResponse.rolls)")

    } catch {
      app.logger.error("Error calling CoreBook API: \(error)")
      throw Abort(
        .internalServerError, reason: "Error communicating with CoreBook API",
        identifier: "coreBookApiError")
    }

    let newMonster: MonsterResponse = MonsterResponse(
      id: UUID(),
      name: creationRequest.name,
      type: creationRequest.type,
      level: creationRequest.requestedLevel ?? Int.random(in: 1...10),  // Default to a random level if not provided
      hits: dieRollResponse.rolls,
      createdAt: Date()
    )
    // --- End of business logic ---

    return newMonster
  }
}

// extension MonsterApiController {
//   struct GetMonsterContext: RouteContext, @unchecked Sendable {
//     typealias RequestBodyType = MonsterCreationRequest  // Expecting MonsterCreationRequest JSON
//     static let defaultContentType: HTTPMediaType? = .json  // Default request body type
//     static let shared: MonsterApiController.GetMonsterContext = Self()
//     let success: ResponseContext<MonsterResponse> = .init { response in
//       response.status = .created
//     }  // HTTP 201 Created for new resource
//   }
// }
