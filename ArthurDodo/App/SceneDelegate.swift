import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let di = DependencyContainer()
    var appCoordinator: Coordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        window?.rootViewController = di.router.setRootNavigation()
        window?.makeKeyAndVisible()

        appCoordinator = di.coordinatorFactory.makeAppCoordinator()
        appCoordinator?.start()

        resetActiveOrder() // Сбрасывает активный заказ (использую для тестирования)
//        resetStories() // Сбрасывает просмотренные сторисы (использую для тестирования)

    }

    // Метод сбрасывает активный заказ для отладки,
    private func resetActiveOrder() {
        UserDefaults.standard.resetActiveOrder()
    }

    private func resetStories() {
        UserDefaults.standard.resetViewedStories()
    }
}
