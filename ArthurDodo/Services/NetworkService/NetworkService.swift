import Foundation

struct NetworkService {

    var networkClient: AsyncAwaitNetworkClient

    init(networkClient: AsyncAwaitNetworkClient) {
        self.networkClient = networkClient
    }

    func fetchUserData() async throws -> User {
        return try await networkClient.fetchData(.personal, type: User.self)
    }

    func fetchStories() async throws -> [Story] {
        return try await networkClient.fetchData(.stories, type: [Story].self)
    }

    func fetchItems() async throws -> [Item] {
        return try await networkClient.fetchData(.items, type: [Item].self)
    }

    func fetchPromo() async throws -> [Promo] {
        return try await networkClient.fetchData(.promo, type: [Promo].self)
    }

    func fetchToppings() async throws -> [Topping] {
        return try await networkClient.fetchData(.toppings, type: [Topping].self)
    }
}
