import Foundation

func withErrorHandling<T>(_ asynchronousOperation: @escaping () async throws -> T) -> () async throws -> T {
    return {
        do {
            return try await asynchronousOperation()
        } catch {
            print("An error occurred:", error)
            throw error
        }
    }
}