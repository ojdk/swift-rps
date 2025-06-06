import Foundation  // Import Foundation for exit()
import MonsterCore  // Import the MonsterCore library

print("MonsterBook: Initializing and starting the MonsterCore web service...")

do {
    // Run the MonsterCore service. This function will block execution
    // as long as the web server is running.
    try MonsterCoreService.run()

    // This line will typically not be reached if the server runs indefinitely,
    // unless MonsterCoreService.run() is designed to return or the server
    // is shut down gracefully from within the service.
    print("MonsterBook: MonsterCore web service has finished.")
} catch {
    // Log the error and exit with a non-zero status code to indicate failure.
    print(
        "MonsterBook: A critical error occurred while starting or running the MonsterCore web service: \(error)"
    )
    #if os(Linux) || os(macOS)
        exit(1)  // Standard POSIX exit code for failure
    #else
        // Fallback for other platforms if necessary, though Vapor primarily targets Apple/Linux.
    #endif
}
