import Foundation

enum Result<T, E: Error> {
    case success(T)
    case failure(E)
    case notFound
}