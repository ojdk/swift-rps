import Vapor

/// Registers the application's routes.
func routes(_ app: Application) throws {
    let apiController = MonsterApiController(app: app)

    // Changed to POST to accept a JSON body, and endpoint name changed
    app.post("monster", use: apiController.getMonster)
}
