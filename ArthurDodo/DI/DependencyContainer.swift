import UIKit

// Контейнер зависимостей. При его создании мы делаем экземпляр навигационного контроллера, который будет управлять навигацией и его мы назначим рутом в sceneDelegate
final class DependencyContainer {
    let networkManager: NetworkManager
    let storage: DataStorage
    let screenFactory: ScreenFactory
    let router: Router
    let coordinatorFactory: CoordinatorFactory

    // тест
    let asyncAwaitNetworkManager: NetworkManagerAsyncAwait
    let startAppService: StartAppService
    let networkService: NetworkService

    init() {
        let decoder = JSONDecoder()
        let encoder = JSONEncoder()
        let session = URLSession(configuration: .default)

        // Создаем сетевой слой
        networkManager = NetworkManager(decoder: decoder, encoder: encoder, session: session)


        // тест
        asyncAwaitNetworkManager = NetworkManagerAsyncAwait(decoder: decoder, encoder: encoder, session: session)


        // Создаем хранилище
        storage = DataStorage(networkManager: networkManager, asyncAwaitNetworkManager: asyncAwaitNetworkManager)

        // тест
        networkService = NetworkService(networkManager: asyncAwaitNetworkManager)
        startAppService = StartAppService(networkService: networkService, storage: storage)


        // Создаем фабрику экранов
        screenFactory = ScreenFactory(storage: storage)

        // Создаем роутер
        router = Router()

        // Создаем фабрику координаторов
        coordinatorFactory = CoordinatorFactory(router: router, screenFactory: screenFactory)
    }
}
