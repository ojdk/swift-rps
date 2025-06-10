import Vapor

/// Called before your application initializes.
/// Sets up routes, middleware, and other configurations.
internal func configure(_ app: Application) throws {
    // Serves files from `Public/` directory if you have one.
    // This is needed to serve openapi.json if you place it in Public/
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // get enviroment variable

    app.http.server.configuration.hostname = "0.0.0.0"
    app.http.server.configuration.port = 8080

    // Register your routes
    try routes(app)

    // You can register other services, databases, etc. here.
}
