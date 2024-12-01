import UIKit

// Контейнер зависимостей. При его создании мы делаем экземпляр навигационного контроллера, который будет управлять навигацией и его мы назначим рутом в sceneDelegate
final class DependencyContainer {
    let storage: DataStorage
    let screenFactory: ScreenFactory
    let router: Router
    let coordinatorFactory: CoordinatorFactory

    // MARK: - Netwok Layer
    //    let networkClient: NetworkManager
    let asyncAwaitNetworkClient: AsyncAwaitNetworkClient
    let startAppService: StartAppService
    let networkService: NetworkService

    init() {
        let decoder = JSONDecoder()
        let encoder = JSONEncoder()
        let session = URLSession(configuration: .default)

        // Создаем сетевой слой
//        networkManager = NetworkManager(decoder: decoder, encoder: encoder, session: session)

        // NetworkClient содержит основные настройки сетевого слоя
        asyncAwaitNetworkClient = AsyncAwaitNetworkClient(decoder: decoder, encoder: encoder, session: session)

        // NetworkService содержит все запросы в сеть
        networkService = NetworkService(networkClient: asyncAwaitNetworkClient)

        // Создаем хранилище
        storage = DataStorage()

        // В сервисе StartAppService происходит сборка всех необходимых запросов в сеть и app подготавливается к работе, чтобы в процессе работы загрузка из сети не производилась. Все необходимые для работы данные загружаются здесь.
        startAppService = StartAppService(networkService: networkService, storage: storage)

        // Создаем фабрику экранов
        screenFactory = ScreenFactory(storage: storage)

        // Создаем роутер
        router = Router()

        // Создаем фабрику координаторов
        coordinatorFactory = CoordinatorFactory(router: router, screenFactory: screenFactory)
    }
}
