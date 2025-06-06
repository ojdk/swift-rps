import Foundation
import Vapor
import VaporOpenAPI
import Yams

final class MonsterApiController {

  let app: Application

  init(app: Application) {
    self.app = app
  }

  func die6(_ req: TypedRequest<DieContext>) -> EventLoopFuture<Response> {
    
    app.logger.info("die6 called")
    return req.response.success.encode(
      """
        {"rolls":[1,2,3,4,5,6]}
      """)

  }

}

extension MonsterApiController {

  struct DieContext: RouteContext, @unchecked Sendable {

    typealias RequestBodyType = EmptyRequestBody

    static let defaultContentType: HTTPMediaType? = nil
    static let shared = Self()

    let success:  ResponseContext<String> = .init { response in
      response.headers.contentType = .init(type: "application", subType: "json")
      response.status = .ok
    }
  }

}
