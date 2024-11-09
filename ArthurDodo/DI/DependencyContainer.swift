import UIKit

// Контейнер зависимостей. При его создании мы делаем экземпляр навигационного контроллера, который будет управлять навигацией и его мы назначим рутом в sceneDelegate
final class DependencyContainer {
    let networkManager: NetworkManager
    let storage: DataStorage
    let screenFactory: ScreenFactory
    let router: Router
    let navigationController: UINavigationController

    init() {
        let navigationController = UINavigationController()
        let decoder = JSONDecoder()
        let encoder = JSONEncoder()
        let session = URLSession(configuration: .default)

        networkManager = NetworkManager(decoder: decoder, encoder: encoder, session: session)
        storage = DataStorage(networkManager: networkManager)
        screenFactory = ScreenFactory()

        self.navigationController = navigationController

        router = Router(navigationController: navigationController)

        router.di = self
        screenFactory.di = self
    }
}
