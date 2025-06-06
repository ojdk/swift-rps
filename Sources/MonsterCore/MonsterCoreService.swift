import Vapor

// LoggingSystem is part of the swift-log API, which Vapor depends on.
// Logger is also from swift-log.

/// `MonsterCoreService` provides the main entry point to run the Vapor web service.
public enum MonsterCoreService {

    /// Initializes and runs the Vapor application.
    /// This function will configure the environment, logging, routes, and then start the server.
    /// It blocks the calling thread until the server is shut down.
    public static func run() throws {
        // Detect the environment (e.g., development, production) from command-line arguments or OS environment variables.
        var env = try Environment.detect()

        // Bootstrap the logging system. It's good practice to do this early.
        // Vapor's Application will also do this if not already initialized.
        try LoggingSystem.bootstrap(from: &env)

        let app = Application(env)
        defer { app.shutdown() }  // Ensures the application cleans up resources on exit.

        try configure(app)  // Apply configurations (routes, middleware, etc.)

        app.logger.info("MonsterCore service starting up...")
        app.logger.info(
            "API will be available at http://\(app.http.server.configuration.hostname):\(app.http.server.configuration.port)"
        )

        try app.run()  // Starts the server and blocks the current thread.
    }
}
