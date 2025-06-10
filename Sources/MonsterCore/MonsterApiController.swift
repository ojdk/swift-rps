import Foundation
import Vapor
import VaporOpenAPI
import Yams

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
  let createdAt: Date
}

final class MonsterApiController {

  let app: Application

  init(app: Application) {
    self.app = app
  }

  func getMonster(_ req: TypedRequest<GetMonsterContext>) async throws -> MonsterResponse {
    app.logger.info(
      "getMonster called")
    let creationRequest: MonsterCreationRequest = try req.content.get(MonsterCreationRequest.self)
    app.logger.info(
      "getMonster called with name: \(creationRequest.name), type: \(creationRequest.type)")

    // --- Business logic for creating a monster would go here ---
    // For now, we'll just simulate it.
    let newMonster: MonsterResponse = MonsterResponse(
      id: UUID(),
      name: creationRequest.name,
      type: creationRequest.type,
      level: creationRequest.requestedLevel ?? Int.random(in: 1...10),  // Default to a random level if not provided
      createdAt: Date()
    )
    // --- End of business logic ---

    return newMonster
  }
}

extension MonsterApiController {
  struct GetMonsterContext: RouteContext, @unchecked Sendable {
    typealias RequestBodyType = MonsterCreationRequest  // Expecting MonsterCreationRequest JSON
    static let defaultContentType: HTTPMediaType? = .json  // Default request body type
    static let shared: MonsterApiController.GetMonsterContext = Self()
    let success: ResponseContext<MonsterResponse> = .init { response in
      response.status = .created
    }  // HTTP 201 Created for new resource
  }
}
