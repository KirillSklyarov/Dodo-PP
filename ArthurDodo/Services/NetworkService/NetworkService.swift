import Foundation

// Сетевой сервис, который отвечает за выполнение сетевых запросов
struct NetworkService {

    // MARK: - Network Client
    let networkClient: AsyncAwaitNetworkClient

    // MARK: - Init
    init(networkClient: AsyncAwaitNetworkClient) {
        self.networkClient = networkClient
    }

    // MARK: - Fetch methods
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

    func fetchFeatures() async throws -> [Feature] {
        return try await networkClient.fetchData(.serverFeaturesToggle, type: [Feature].self)
    }
}
