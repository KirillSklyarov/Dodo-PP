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

        startApp()


        resetActiveOrder() // Сбрасывает активный заказ (использую для тестирования)
//        resetStories() // Сбрасывает просмотренные сторисы (использую для тестирования)

    }

    // Загружаем данные с сервера, потом стартуем главный координатор
    private func startApp() {
        appCoordinator = di.coordinatorFactory.makeAppCoordinator()

        Task {
            await di.startAppService.fetchAllData()
            appCoordinator?.start()
        }
    }

    // Метод сбрасывает активный заказ для отладки,
    private func resetActiveOrder() {
        UserDefaults.standard.resetActiveOrder()
    }

    private func resetStories() {
        UserDefaults.standard.resetViewedStories()
    }
}
