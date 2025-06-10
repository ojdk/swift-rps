import Core  // Import the MonsterCore library
import Foundation  // Import Foundation for exit()

print("CoreBook: Initializing and starting the Core web service...")

do {
    // Run the Core service. This function will block execution
    // as long as the web server is running.
    try CoreService.run()

    // This line will typically not be reached if the server runs indefinitely,
    // unless CoreService.run() is designed to return or the server
    // is shut down gracefully from within the service.
    print("CoreBook: Core web service has finished.")
} catch {
    // Log the error and exit with a non-zero status code to indicate failure.
    print(
        "CoreBook: A critical error occurred while starting or running the Core web service: \(error)"
    )
    #if os(Linux) || os(macOS)
        exit(1)  // Standard POSIX exit code for failure
    #else
        // Fallback for other platforms if necessary, though Vapor primarily targets Apple/Linux.
    #endif
}
