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

        // Создаем сетевой слой
        networkManager = NetworkManager(decoder: decoder, encoder: encoder, session: session)

        // Создаем хранилище
        storage = DataStorage(networkManager: networkManager)

        // Создаем фабрику экранов
        screenFactory = ScreenFactory(storage: storage)

        // Создаем роутер
        router = Router()

        // Создаем главный координатор
        appCoordinator = AppCoordinator(router: router, screenFactory: screenFactory)
    }
}
