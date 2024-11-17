import UIKit

// Контейнер зависимостей. При его создании мы делаем экземпляр навигационного контроллера, который будет управлять навигацией и его мы назначим рутом в sceneDelegate
final class DependencyContainer {
    let networkManager: NetworkManager
    let storage: DataStorage
    let screenFactory: ScreenFactory
    let router: Router
    let appCoordinator: AppCoordinator

    init() {
        let decoder = JSONDecoder()
        let encoder = JSONEncoder()
        let session = URLSession(configuration: .default)

        networkManager = NetworkManager(decoder: decoder, encoder: encoder, session: session)
        storage = DataStorage(networkManager: networkManager)
        screenFactory = ScreenFactory(storage: storage)

        router = Router(screenFactory: screenFactory)

        screenFactory.router = router

        appCoordinator = AppCoordinator(storage: storage, router: router, screenFactory: screenFactory)
    }
}
