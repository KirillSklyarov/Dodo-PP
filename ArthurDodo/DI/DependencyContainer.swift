import UIKit

// Контейнер зависимостей. При его создании мы делаем экземпляр навигационного контроллера, который будет управлять навигацией и его мы назначим рутом в sceneDelegate
final class DependencyContainer {
    let storage: DataStorage
    let networkManager: NetworkManager
    let screenFactory: ScreenFactory
    let router: Router
    let navigationController: UINavigationController

    init() {
        self.navigationController = UINavigationController()
        let decoder = JSONDecoder()
        let encoder = JSONEncoder()

        networkManager = NetworkManager(decoder: decoder, encoder: encoder)
        storage = DataStorage(networkManager: networkManager)
        screenFactory = ScreenFactory()

        router = Router(navigationController: self.navigationController)
        router.di = self

        screenFactory.di = self
    }
}
