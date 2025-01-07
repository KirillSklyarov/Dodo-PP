import Foundation

enum BaseScreenState<T> {
    case initial
    case loading
    case success(T)
    case error
}
