import Vapor

/// Registers the application's routes.
func routes(_ app: Application, _ apiController: MonsterApiController) throws {

    // Changed to POST to accept a JSON body, and endpoint name changed
    app.post("monster", use: apiController.getMonster)
}
