import Vapor

// Registers the application's routes.
func routes(_ app: Application) throws {
    let apiController = CoreApiController(app: app)
    app.get("roll", ":dieType", ":count", use: apiController.rollDice)
}
