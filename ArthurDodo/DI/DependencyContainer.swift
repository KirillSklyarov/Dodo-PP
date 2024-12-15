import UIKit

// Контейнер зависимостей. При его создании мы делаем экземпляр навигационного контроллера, который будет управлять навигацией и его мы назначим рутом в sceneDelegate
final class DependencyContainer {
    let storage: DataStorage
    let screenFactory: ScreenFactory
    let router: Router
    let coordinatorFactory: CoordinatorFactory

    let networkClient: AsyncAwaitNetworkClient
    let networkService: NetworkService

    let appStartManager: AppStartManager
    let featureToggleService: FeatureToggleService

    init() {
        let decoder = JSONDecoder()
        let encoder = JSONEncoder()
        let session = URLSession(configuration: .default)

        // NetworkClient содержит основные настройки сетевого слоя
        networkClient = AsyncAwaitNetworkClient(decoder: decoder, encoder: encoder, session: session)

        // NetworkService содержит все запросы в сеть
        networkService = NetworkService(networkClient: networkClient)

        // Создаем хранилище
        storage = DataStorage()

        featureToggleService = FeatureToggleService(networkService: networkService, storage: storage, decoder: decoder, encoder: encoder, session: session)


        //        AppStartManager(networkService: networkService, storage: storage)

        // Создаем фабрику экранов
        screenFactory = ScreenFactory(storageService: storage)

        // Создаем роутер
        router = Router()

        // Создаем фабрику координаторов
        coordinatorFactory = CoordinatorFactory(router: router, screenFactory: screenFactory, storage: storage)

        // В сервисе AppStartManager происходит сборка всех необходимых запросов в сеть и app подготавливается к работе, чтобы в процессе работы загрузка из сети не производилась. Все необходимые для работы данные загружаются здесь.
        appStartManager = AppStartManager(networkService: networkService, storage: storage, featureToggleService: featureToggleService, screenFactory: screenFactory, router: router, coordinatorFactory: coordinatorFactory)
    }

}
