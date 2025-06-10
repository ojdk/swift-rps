import Vapor

/// Registers the application's routes.
func routes(_ app: Application) throws {
    let apiController = CoreApiController(app: app)

    app.get("die6", use: apiController.die6)

}
