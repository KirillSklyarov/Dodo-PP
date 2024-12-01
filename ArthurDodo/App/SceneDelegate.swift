import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private let di = DependencyContainer()
    private var appCoordinator: Coordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        window?.rootViewController = di.router.setRootNavigation()
        window?.makeKeyAndVisible()

        setAppCoordinator()
        startApp()

        resetActiveOrder() // Сбрасывает активный заказ (использую для тестирования)
    }
}

// MARK: - Supporting methods
private extension SceneDelegate {
    // Сначала загружаем данные с сервера, и только потом стартует главный координатор
    private func startApp() {
        Task {
            await di.startAppService.fetchAllData()
            appCoordinator?.start()
        }
    }

    // Назначаем основной координатор приложения
    private func setAppCoordinator() {
        appCoordinator = di.coordinatorFactory.makeAppCoordinator()
    }

    // Метод сбрасывает активный заказ для отладки,
    private func resetActiveOrder() {
        UserDefaults.standard.resetActiveOrder()
    }

    // Сбрасывает просмотренные сторисы (использую для тестирования)
    private func resetStories() {
        UserDefaults.standard.resetViewedStories()
    }
}
