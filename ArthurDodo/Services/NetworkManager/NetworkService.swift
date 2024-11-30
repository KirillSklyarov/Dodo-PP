import Foundation

struct NetworkService {

    var networkManager: NetworkManagerAsyncAwait

    init(networkManager: NetworkManagerAsyncAwait) {
        self.networkManager = networkManager
    }

    func fetchUserData() async throws -> User {
        return try await networkManager.fetchData(.personal, type: User.self)
    }

    func fetchStories() async throws -> [Story] {
        return try await networkManager.fetchData(.stories, type: [Story].self)
    }

    func fetchItems() async throws -> [Item] {
        return try await networkManager.fetchData(.items, type: [Item].self)
    }

    func fetchPromo() async throws -> [Promo] {
        return try await networkManager.fetchData(.promo, type: [Promo].self)
    }
}
